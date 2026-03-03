from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import uvicorn
from backend.app.api.endpoints import air_quality
from backend.app.db.session import db
from backend.app.services.scheduler import scheduler_service
from backend.app.core.config import settings

app = FastAPI(title=settings.PROJECT_NAME)

# Include routers
app.include_router(air_quality.router, prefix="/api")

# Static files
app.mount("/static", StaticFiles(directory="frontend"), name="static")

@app.on_event("startup")
async def on_startup():
    try:
        db.init_db()
        scheduler_service.start()
    except Exception as e:
        print(f"[STARTUP ERROR] {e}")

@app.on_event("shutdown")
async def on_shutdown():
    scheduler_service.shutdown()

@app.get("/")
async def read_index():
    return FileResponse("frontend/index.html")

if __name__ == "__main__":
    print("=" * 50)
    print(f" {settings.PROJECT_NAME} starting...")
    print(f" Token: {'SET' if settings.WAQI_TOKEN else 'NOT SET!'}")
    print(f" Open: http://127.0.0.1:8000")
    print("=" * 50)
    uvicorn.run("backend.app.main:app", host="0.0.0.0", port=8000, reload=True)
