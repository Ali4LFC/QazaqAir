from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
import bcrypt
from pydantic import BaseModel, EmailStr
from sqlalchemy import select, insert, update

from app.core.config import settings
from app.db.session import db

router = APIRouter()

# Security
SECRET_KEY = settings.SECRET_KEY if hasattr(settings, 'SECRET_KEY') else "your-secret-key-here-change-in-production"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# Using bcrypt directly (compatible with bcrypt 4.x)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")


# Pydantic models
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: str


class UserUpdate(BaseModel):
    name: Optional[str] = None
    city_key: Optional[str] = None


class UserResponse(BaseModel):
    id: int
    email: str
    name: str
    city_key: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse


class TokenData(BaseModel):
    email: Optional[str] = None


# Helper functions
def verify_password(plain_password, hashed_password):
    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))


def get_password_hash(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except JWTError:
        raise credentials_exception
    
    # Get user from database
    if db.engine is None or db.users_table is None:
        raise credentials_exception
    
    with db.engine.connect() as conn:
        result = conn.execute(
            select(db.users_table).where(db.users_table.c.email == token_data.email)
        ).fetchone()
        
        if result is None:
            raise credentials_exception
        
        return dict(result._mapping)


async def get_current_active_user(current_user: dict = Depends(get_current_user)):
    if not current_user.get("is_active", True):
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


# Endpoints
@router.post("/register", response_model=dict)
async def register(user_data: UserCreate):
    if db.engine is None or db.users_table is None:
        raise HTTPException(status_code=503, detail="Database not available")
    
    # Check if user exists
    with db.engine.connect() as conn:
        result = conn.execute(
            select(db.users_table).where(db.users_table.c.email == user_data.email)
        ).fetchone()
        
        if result:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
    
    # Create new user
    hashed_password = get_password_hash(user_data.password)
    
    with db.engine.begin() as conn:
        result = conn.execute(
            insert(db.users_table).values(
                email=user_data.email,
                hashed_password=hashed_password,
                name=user_data.name,
                city_key=None,
                is_active=True,
                created_at=datetime.utcnow()
            ).returning(db.users_table.c.id, db.users_table.c.email, db.users_table.c.name, 
                       db.users_table.c.city_key, db.users_table.c.created_at)
        )
        new_user = result.fetchone()
    
    return {
        "message": "User created successfully",
        "user": {
            "id": new_user.id,
            "email": new_user.email,
            "name": new_user.name,
            "city_key": new_user.city_key,
            "created_at": new_user.created_at
        }
    }


@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    if db.engine is None or db.users_table is None:
        raise HTTPException(status_code=503, detail="Database not available")
    
    # Find user by email
    with db.engine.connect() as conn:
        result = conn.execute(
            select(db.users_table).where(db.users_table.c.email == form_data.username)
        ).fetchone()
        
        if not result:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        user = dict(result._mapping)
    
    # Verify password
    if not verify_password(form_data.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Create access token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user["email"]}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user["id"],
            "email": user["email"],
            "name": user["name"],
            "city_key": user["city_key"],
            "created_at": user["created_at"]
        }
    }


@router.get("/me", response_model=UserResponse)
async def read_users_me(current_user: dict = Depends(get_current_active_user)):
    return {
        "id": current_user["id"],
        "email": current_user["email"],
        "name": current_user["name"],
        "city_key": current_user["city_key"],
        "created_at": current_user["created_at"]
    }


@router.patch("/me", response_model=UserResponse)
async def update_user(
    user_update: UserUpdate,
    current_user: dict = Depends(get_current_active_user)
):
    if db.engine is None or db.users_table is None:
        raise HTTPException(status_code=503, detail="Database not available")
    
    update_data = {}
    if user_update.name is not None:
        update_data["name"] = user_update.name
    if user_update.city_key is not None:
        update_data["city_key"] = user_update.city_key
    
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    with db.engine.begin() as conn:
        result = conn.execute(
            update(db.users_table)
            .where(db.users_table.c.id == current_user["id"])
            .values(**update_data)
            .returning(db.users_table.c.id, db.users_table.c.email, db.users_table.c.name,
                      db.users_table.c.city_key, db.users_table.c.created_at)
        )
        updated_user = result.fetchone()
    
    return {
        "id": updated_user.id,
        "email": updated_user.email,
        "name": updated_user.name,
        "city_key": updated_user.city_key,
        "created_at": updated_user.created_at
    }
