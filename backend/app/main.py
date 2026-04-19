from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import os
import uvicorn
from app.api.endpoints import air_quality, auth
from app.db.session import db
from app.services.scheduler import scheduler_service
from app.core.config import settings
from starlette.responses import Response, HTMLResponse
from starlette.middleware.base import BaseHTTPMiddleware
import time
import asyncio
from collections import deque
from typing import Deque, Dict, Tuple

# Try multiple possible paths for frontend_new
frontend_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../frontend_new"))
if not os.path.exists(frontend_path):
    frontend_path = "frontend_new" # Fallback to current directory

app = FastAPI(title=settings.PROJECT_NAME)

# CORS middleware for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],  # Vite dev server
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class FirewallMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        path = request.url.path
        if path.startswith("/static"):
            return await call_next(request)
        ip = None
        if settings.TRUST_X_FORWARDED:
            xff = request.headers.get("x-forwarded-for", "")
            if xff:
                ip = xff.split(",")[0].strip()
        if not ip:
            client = request.client
            ip = client.host if client else "unknown"
        if ip in ("::1", "0:0:0:0:0:0:0:1"):
            ip = "127.0.0.1"
        if ip.startswith("::ffff:"):
            ip = ip.split("::ffff:")[-1]
        if settings.ALLOWED_IPS and ip not in settings.ALLOWED_IPS:
            accepts_html = "text/html" in (request.headers.get("accept", "").lower())
            if accepts_html and not path.startswith("/api"):
                html_403 = os.path.join(frontend_path, "403.html")
                if os.path.exists(html_403):
                    return FileResponse(html_403, status_code=403, media_type="text/html")
                return HTMLResponse("<h1>403 Forbidden</h1>", status_code=403)
            return JSONResponse({"detail": "forbidden"}, status_code=403)
        if settings.BLOCKED_IPS and ip in settings.BLOCKED_IPS:
            accepts_html = "text/html" in (request.headers.get("accept", "").lower())
            if accepts_html and not path.startswith("/api"):
                html_403 = os.path.join(frontend_path, "403.html")
                if os.path.exists(html_403):
                    return FileResponse(html_403, status_code=403, media_type="text/html")
                return HTMLResponse("<h1>403 Forbidden</h1>", status_code=403)
            return JSONResponse({"detail": "forbidden"}, status_code=403)
        return await call_next(request)

class RateLimitMiddleware(BaseHTTPMiddleware):
    store: Dict[Tuple[str, str], Deque[float]] = {}
    async def dispatch(self, request: Request, call_next):
        path = request.url.path
        if not path.startswith("/api"):
            return await call_next(request)
        ip = None
        if settings.TRUST_X_FORWARDED:
            xff = request.headers.get("x-forwarded-for", "")
            if xff:
                ip = xff.split(",")[0].strip()
        if not ip:
            client = request.client
            ip = client.host if client else "unknown"
        if ip in ("::1", "0:0:0:0:0:0:0:1"):
            ip = "127.0.0.1"
        if ip.startswith("::ffff:"):
            ip = ip.split("::ffff:")[-1]
        key = (ip, path)
        now = time.time()
        window = settings.RATE_LIMIT_WINDOW_SECONDS
        limit = settings.RATE_LIMIT_MAX_REQUESTS
        q = self.store.get(key)
        if q is None:
            q = deque()
            self.store[key] = q
        while q and now - q[0] > window:
            q.popleft()
        if len(q) >= limit:
            retry_after = int(window - (now - q[0])) if q else window
            headers = {"Retry-After": str(max(retry_after, 1))}
            return JSONResponse({"detail": "too_many_requests"}, status_code=429, headers=headers)
        q.append(now)
        return await call_next(request)

# Middlewares
app.add_middleware(FirewallMiddleware)
app.add_middleware(RateLimitMiddleware)

# API Routers
app.include_router(air_quality.router, prefix="/api")
app.include_router(auth.router, prefix="/api/auth")

if os.path.exists(frontend_path):
    app.mount("/static", StaticFiles(directory=frontend_path), name="static")
else:
    print(f"[WARNING] Frontend directory not found at {frontend_path}")


@app.on_event("startup")
async def on_startup():
    try:
        db.init_db()
        scheduler_service.start()
        
        # SSH Server
        from app.services.ssh_service import start_ssh_server
        asyncio.create_task(start_ssh_server())
        
        # Предварительный прогрев кеша для всех регионов в фоновом режиме
        from app.api.endpoints.air_quality import get_summary
        asyncio.create_task(get_summary())
    except Exception as e:
        print(f"[STARTUP ERROR] {e}")

@app.on_event("shutdown")
async def on_shutdown():
    scheduler_service.shutdown()

@app.get("/")
async def read_index():
    index_path = os.path.join(frontend_path, "index.html")
    if os.path.exists(index_path):
        return FileResponse(index_path)
    return HTMLResponse("<h1>Backend is running!</h1><p>Frontend not found.</p>")

if __name__ == "__main__":
    # Check if SSL files actually exist
    ssl_certfile = settings.SSL_CERTFILE if settings.SSL_CERTFILE and os.path.exists(settings.SSL_CERTFILE) else None
    ssl_keyfile = settings.SSL_KEYFILE if settings.SSL_KEYFILE and os.path.exists(settings.SSL_KEYFILE) else None
    
    print("=" * 50)
    print(f" {settings.PROJECT_NAME} starting...")
    print(f" Token: {'SET' if settings.WAQI_TOKEN else 'NOT SET!'}")
    scheme = "https" if (ssl_certfile and ssl_keyfile) else "http"
    print(f" Open: {scheme}://127.0.0.1:8000")
    print("=" * 50)
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        ssl_certfile=ssl_certfile,
        ssl_keyfile=ssl_keyfile,
    )
