from sqlalchemy import create_engine, Table, Column, Integer, String, Float, DateTime, MetaData, UniqueConstraint, Boolean
from sqlalchemy.engine import URL
from urllib.parse import urlparse, unquote
from app.core.config import settings

class Database:
    def __init__(self):
        self.engine = None
        self.table = None
        self.users_table = None
        self.meta = MetaData()

    def init_db(self):
        if not settings.POSTGRES_URL:
            print("[DB ERROR] POSTGRES_URL не установлен в .env")
            return
        try:
            u = urlparse(settings.POSTGRES_URL)
            username = unquote(u.username) if u.username else None
            password = unquote(u.password) if u.password else None
            
            db_url = URL.create(
                drivername="postgresql+psycopg2",
                username=username,
                password=password,
                host=u.hostname,
                port=u.port or 5432,
                database=(u.path or "").lstrip("/"),
            )
            
            self.engine = create_engine(db_url, pool_pre_ping=True, future=True)
            
            # AQI hourly data table
            self.table = Table(
                "aqi_hourly",
                self.meta,
                Column("id", Integer, primary_key=True, autoincrement=True),
                Column("region_key", String(64), index=True, nullable=False),
                Column("city", String(128), nullable=False),
                Column("ts_hour", DateTime, index=True, nullable=False),
                Column("aqi", Integer, nullable=True),
                Column("temp_c", Float, nullable=True),
                Column("humidity_pct", Integer, nullable=True),
                Column("wind_ms", Float, nullable=True),
                UniqueConstraint("region_key", "ts_hour", name="uq_region_hour"),
            )
            
            # Users table
            self.users_table = Table(
                "users",
                self.meta,
                Column("id", Integer, primary_key=True, autoincrement=True),
                Column("email", String(255), unique=True, nullable=False, index=True),
                Column("hashed_password", String(255), nullable=False),
                Column("name", String(255), nullable=False),
                Column("city_key", String(64), nullable=True),
                Column("is_active", Boolean, default=True),
                Column("created_at", DateTime, nullable=False),
            )
            
            self.meta.create_all(self.engine)
            print("[DB] Connection initialized and tables checked.")
        except Exception as e:
            print(f"[DB ERROR] Failed to initialize DB: {e}")
            self.engine = None
            self.table = None
            self.users_table = None

db = Database()
