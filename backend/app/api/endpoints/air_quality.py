import asyncio
import re
from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel, Field
from fastapi.responses import JSONResponse
import httpx
from sqlalchemy import select, inspect
from sqlalchemy.exc import SQLAlchemyError
from app.core.config import settings
from app.services.waqi_service import waqi_service
from app.services.scheduler import scheduler_service
from app.db.session import db

router = APIRouter()


class AssistantRequest(BaseModel):
    question: str = Field(min_length=2, max_length=400)
    region: str | None = None


class AssistantResponse(BaseModel):
    answer: str
    region: str


BLOCKED_TOPICS = [
    "код", "code", "github", "repo", "репозитор", "парол", "password", "secret", "token",
    "ключ", "api key", "docker", "compose", "sql", "ssh", "конфиг", "config", "env",
]


def _extract_region_from_question(question: str):
    normalized_question = question.strip().lower()
    if not normalized_question:
        return None

    for region in settings.REGIONS:
        candidates = [
            region.get("key"),
            region.get("name"),
            region.get("name_kk"),
            region.get("city"),
            *(region.get("aliases") or []),
        ]

        for candidate in candidates:
            if not candidate:
                continue
            needle = str(candidate).strip().lower()
            if not needle:
                continue
            if re.search(rf"(?<!\w){re.escape(needle)}(?!\w)", normalized_question):
                return region

    return None


def _aqi_level_text(aqi: int) -> str:
    if aqi <= 50:
        return "Хорошее"
    if aqi <= 100:
        return "Умеренное"
    if aqi <= 150:
        return "Вредно для чувствительных групп"
    if aqi <= 200:
        return "Вредное"
    if aqi <= 300:
        return "Очень вредное"
    return "Опасное"


def _safety_advice(aqi: int) -> str:
    if aqi <= 50:
        return "Можно проводить время на улице без ограничений."
    if aqi <= 100:
        return "Для большинства людей воздух приемлем, но чувствительным группам лучше сократить длительные нагрузки."
    if aqi <= 150:
        return "Детям, пожилым и людям с заболеваниями дыхательных путей лучше сократить время на улице."
    if aqi <= 200:
        return "Рекомендуется ограничить активность на открытом воздухе и по возможности использовать маску."
    return "Лучше минимизировать пребывание на улице, держать окна закрытыми и использовать очиститель воздуха."

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


@router.post("/assistant", response_model=AssistantResponse)
async def site_assistant(payload: AssistantRequest):
    q = payload.question.strip().lower()
    if any(topic in q for topic in BLOCKED_TOPICS):
        return AssistantResponse(
            answer="Я помогаю только по погоде и качеству воздуха. По коду, секретам и внутренней инфраструктуре не консультирую.",
            region="n/a",
        )

    region_name = settings.CITY
    try:
        region_from_question = _extract_region_from_question(payload.question)

        if payload.region:
            region_from_payload = waqi_service.get_region_by_key_or_name(payload.region)
            if not region_from_payload:
                raise HTTPException(status_code=404, detail="Region not found")
        else:
            region_from_payload = None

        resolved_region = region_from_question or region_from_payload

        if resolved_region:
            region_name = resolved_region["name"]
            cached = waqi_service._cache_get(resolved_region["key"])
            data = cached if cached else await waqi_service.fetch_for_region(resolved_region)
            if not cached:
                waqi_service._cache_set(resolved_region["key"], data)
        else:
            cached = waqi_service._cache_get(settings.CITY.lower())
            data = cached if cached else await waqi_service.fetch_city_data(settings.CITY)
            if not cached:
                waqi_service._cache_set(settings.CITY.lower(), data)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Assistant request failed: {str(e)}")

    weather = data["current"]["weather"]
    pollution = data["current"]["pollution"]
    temp = weather.get("tp")
    humidity = weather.get("hu")
    wind = weather.get("ws")
    aqi = int(pollution.get("aqius") or 0)
    aqi_level = _aqi_level_text(aqi)
    advice = _safety_advice(aqi)

    answer = (
        f"Регион: {region_name}. Сейчас: температура {temp}°C, влажность {humidity}%, ветер {wind} м/с. "
        f"Индекс качества воздуха AQI: {aqi} ({aqi_level}). {advice}"
    )

    return AssistantResponse(answer=answer, region=region_name)
