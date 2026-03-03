import asyncio
from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
import httpx
from sqlalchemy import select, inspect
from sqlalchemy.exc import SQLAlchemyError
from backend.app.core.config import settings
from backend.app.services.waqi_service import waqi_service
from backend.app.services.scheduler import scheduler_service
from backend.app.db.session import db

router = APIRouter()

@router.get("/air-quality")
async def get_air_quality(region: str | None = Query(default=None)):
    try:
        if region:
            r = waqi_service.get_region_by_key_or_name(region)
            if not r:
                raise HTTPException(status_code=404, detail="Region not found")
            cached = waqi_service._cache_get(r["key"])
            if cached:
                return cached
            data = await waqi_service.fetch_for_region(r)
            data["region"] = {"key": r["key"], "name": r["name"], "coords": r["coords"]}
            waqi_service._cache_set(r["key"], data)
            return data
            
        cached = waqi_service._cache_get(settings.CITY.lower())
        if cached:
            return cached
        data = await waqi_service.fetch_city_data(settings.CITY)
        waqi_service._cache_set(settings.CITY.lower(), data)
        return data
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")

@router.get("/debug")
async def debug_info():
    return {
        "token_set": bool(settings.WAQI_TOKEN),
        "token_prefix": settings.WAQI_TOKEN[:8] + "..." if settings.WAQI_TOKEN else "NOT SET",
        "city": settings.CITY,
        "regions_cached": list(waqi_service.cache["regions"].keys()),
    }

@router.get("/regions")
async def get_regions():
    return [{"key": r["key"], "name": r["name"], "name_kk": r.get("name_kk"), "city": r["city"], "coords": r["coords"]} for r in settings.REGIONS]

@router.get("/summary")
async def get_summary():
    async def get_region_aqi(r):
        c = waqi_service._cache_get(r["key"])
        if c:
            aq = c["current"]["pollution"]["aqius"]
            return {"region": r["name"], "name_kk": r.get("name_kk"), "key": r["key"], "aqi": aq}
        try:
            d = await waqi_service.fetch_for_region(r)
            aq = int(d["current"]["pollution"]["aqius"]) if d["current"]["pollution"]["aqius"] is not None else None
            if aq is not None:
                waqi_service._cache_set(r["key"], d)
            return {"region": r["name"], "name_kk": r.get("name_kk"), "key": r["key"], "aqi": aq}
        except Exception:
            return {"region": r["name"], "name_kk": r.get("name_kk"), "key": r["key"], "aqi": None}

    tasks = [get_region_aqi(r) for r in settings.REGIONS]
    results = await asyncio.gather(*tasks)
        
    clean = [x for x in results if isinstance(x["aqi"], int)]
    clean_sorted = sorted(clean, key=lambda x: x["aqi"])
    dirty_sorted = list(reversed(clean_sorted))
    return {"clean": clean_sorted[:10], "dirty": dirty_sorted[:10]}

@router.post("/save-hourly")
async def save_hourly():
    try:
        result = scheduler_service.save_all_regions_now()
        return result
    except Exception as e:
        return JSONResponse(status_code=200, content={"ok": False, "reason": str(e)})

@router.get("/db-status")
async def db_status():
    configured = bool(settings.POSTGRES_URL)
    connected = False
    table_exists = False
    err = None
    try:
        if db.engine:
            with db.engine.connect() as conn:
                conn.execute(select(1))
                connected = True
            inspector = inspect(db.engine)
            table_exists = inspector.has_table("aqi_hourly")
    except SQLAlchemyError as e:
        err = str(e)
    except Exception as e:
        err = str(e)
        
    url_prefix = settings.POSTGRES_URL.split("@")[0] + "@..." if settings.POSTGRES_URL else None
    return {
        "configured": configured,
        "connected": connected,
        "table_exists": table_exists,
        "url": url_prefix,
        "error": err
    }
