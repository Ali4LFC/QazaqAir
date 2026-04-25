import asyncio
import difflib
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

LANG_PATTERNS = {
    "ru": ["какая", "погода", "влажность", "ветер", "воздух", "алер", "покажи"],
    "kk": ["қандай", "ауа райы", "ылғал", "жел", "ауа", "көрсет", "ластану"],
    "en": ["weather", "humidity", "wind", "air", "aqi", "show", "alerts"],
}


def _normalize_text(value: str) -> str:
    normalized = (value or "").strip().lower().replace("ё", "е")
    normalized = re.sub(r"[^\w\s-]", " ", normalized, flags=re.UNICODE)
    normalized = re.sub(r"\s+", " ", normalized).strip()
    return normalized


def _detect_language(question: str) -> str:
    q = _normalize_text(question)
    if not q:
        return "ru"

    scores = {"ru": 0, "kk": 0, "en": 0}
    for lang, markers in LANG_PATTERNS.items():
        for marker in markers:
            if marker in q:
                scores[lang] += 1

    if re.search(r"[a-z]", q):
        scores["en"] += 1

    if re.search(r"[әіңғүұқөһ]", q):
        scores["kk"] += 2

    return max(scores, key=scores.get)


def _best_fuzzy_match(question: str, candidates: list[str]) -> str | None:
    if not candidates:
        return None

    q = _normalize_text(question)
    if not q:
        return None

    words = q.split()
    ngrams = set(words)
    for i in range(len(words) - 1):
        ngrams.add(f"{words[i]} {words[i + 1]}")

    best = None
    best_score = 0.0
    for candidate in candidates:
        c = _normalize_text(candidate)
        if not c:
            continue
        local_scores = [difflib.SequenceMatcher(None, c, token).ratio() for token in ngrams]
        local_scores.append(difflib.SequenceMatcher(None, c, q).ratio())
        score = max(local_scores)
        if score > best_score:
            best = candidate
            best_score = score

    return best if best_score >= 0.78 else None


def _extract_region_from_question(question: str):
    normalized_question = _normalize_text(question)
    if not normalized_question:
        return None

    all_candidates: list[tuple[str, dict]] = []

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
            needle = _normalize_text(str(candidate))
            if not needle:
                continue
            all_candidates.append((str(candidate), region))
            if re.search(rf"(?<!\w){re.escape(needle)}(?!\w)", normalized_question):
                return region

    fuzzy = _best_fuzzy_match(normalized_question, [c[0] for c in all_candidates])
    if fuzzy:
        for candidate, region in all_candidates:
            if candidate == fuzzy:
                return region

    return None


def _is_weather_context(question: str, lang: str) -> bool:
    q = _normalize_text(question)
    if len(q) < 3:
        return False

    weather_markers = {
        "ru": ["погод", "температур", "влаж", "ветер", "aqi", "воздух", "смог", "загряз"],
        "kk": ["ауа рай", "температура", "ылғал", "жел", "aqi", "ауа", "түтін", "ластан"],
        "en": ["weather", "temperature", "humidity", "wind", "aqi", "air", "pollution", "smog"],
    }
    markers = weather_markers.get(lang, weather_markers["ru"])
    if any(marker in q for marker in markers):
        return True

    conversational = {
        "ru": ["как там", "что по", "ну и", "а сейчас", "сегодня", "завтра"],
        "kk": ["қалай", "қазір", "бүгін", "ертең"],
        "en": ["how is", "what about", "now", "today", "tomorrow"],
    }
    return any(marker in q for marker in conversational.get(lang, []))


def _build_assistant_answer(*, lang: str, region_name: str, temp, humidity, wind, aqi: int, aqi_level: str, advice: str) -> str:
    if lang == "en":
        return (
            f"Region: {region_name}. Current conditions: temperature {temp}°C, humidity {humidity}%, wind {wind} m/s. "
            f"Air Quality Index AQI: {aqi} ({aqi_level}). {advice}"
        )
    if lang == "kk":
        return (
            f"Өңір: {region_name}. Қазір: температура {temp}°C, ылғалдылық {humidity}%, жел {wind} м/с. "
            f"Ауа сапасы индексі AQI: {aqi} ({aqi_level}). {advice}"
        )
    return (
        f"Регион: {region_name}. Сейчас: температура {temp}°C, влажность {humidity}%, ветер {wind} м/с. "
        f"Индекс качества воздуха AQI: {aqi} ({aqi_level}). {advice}"
    )


def _build_assistant_system_prompt(lang: str) -> str:
    if lang == "en":
        return (
            "You are a weather and air-quality assistant for Kazakhstan. "
            "Answer only using provided weather/AQI facts. "
            "Do not reveal code, secrets, infrastructure, tokens, or internal system details. "
            "Keep answers concise and practical."
        )
    if lang == "kk":
        return (
            "Сен Қазақстан бойынша ауа райы мен ауа сапасы көмекшісісің. "
            "Жауапты тек берілген ауа райы/AQI деректеріне сүйеніп бер. "
            "Код, құпия дерек, инфрақұрылым, токен немесе ішкі жүйе мәліметтерін ашпа. "
            "Жауап қысқа әрі пайдалы болсын."
        )
    return (
        "Ты помощник по погоде и качеству воздуха в Казахстане. "
        "Отвечай только на основе переданных фактов о погоде и AQI. "
        "Не раскрывай код, секреты, инфраструктуру, токены и внутренние детали системы. "
        "Ответ должен быть кратким и практичным."
    )


def _build_assistant_user_prompt(*, question: str, lang: str, region_name: str, temp, humidity, wind, aqi: int, aqi_level: str, advice: str) -> str:
    return (
        f"lang={lang}\n"
        f"user_question={question}\n"
        f"region={region_name}\n"
        f"temperature_c={temp}\n"
        f"humidity_pct={humidity}\n"
        f"wind_mps={wind}\n"
        f"aqi={aqi}\n"
        f"aqi_level={aqi_level}\n"
        f"advice={advice}\n"
        "Сформируй короткий ответ пользователю на соответствующем языке."
    )


async def _try_llm_assistant_answer(*, question: str, lang: str, region_name: str, temp, humidity, wind, aqi: int, aqi_level: str, advice: str) -> str | None:
    if not settings.OPENAI_API_KEY:
        return None

    base_url = (settings.OPENAI_API_BASE or "https://api.openai.com/v1").rstrip("/")
    url = f"{base_url}/chat/completions"
    payload = {
        "model": settings.AI_MODEL,
        "temperature": 0.2,
        "messages": [
            {"role": "system", "content": _build_assistant_system_prompt(lang)},
            {
                "role": "user",
                "content": _build_assistant_user_prompt(
                    question=question,
                    lang=lang,
                    region_name=region_name,
                    temp=temp,
                    humidity=humidity,
                    wind=wind,
                    aqi=aqi,
                    aqi_level=aqi_level,
                    advice=advice,
                ),
            },
        ],
    }

    headers = {
        "Authorization": f"Bearer {settings.OPENAI_API_KEY}",
        "Content-Type": "application/json",
    }

    try:
        async with httpx.AsyncClient(timeout=12.0) as client:
            response = await client.post(url, headers=headers, json=payload)
            response.raise_for_status()
            data = response.json()
            content = (
                data.get("choices", [{}])[0]
                .get("message", {})
                .get("content", "")
                .strip()
            )
            return content or None
    except Exception:
        return None


def _build_topic_guard_message(lang: str) -> str:
    if lang == "en":
        return "I can only help with weather and air quality. I do not provide code, secrets, or internal infrastructure details."
    if lang == "kk":
        return "Мен тек ауа райы мен ауа сапасы туралы көмектесемін. Код, құпия деректер және ішкі инфрақұрылым туралы айтпаймын."
    return "Я помогаю только по погоде и качеству воздуха. По коду, секретам и внутренней инфраструктуре не консультирую."


def _localize_aqi_level(aqi: int, lang: str) -> str:
    levels = {
        "ru": ["Хорошее", "Умеренное", "Вредно для чувствительных групп", "Вредное", "Очень вредное", "Опасное"],
        "kk": ["Жақсы", "Орташа", "Сезімтал топтарға зиян", "Зиянды", "Өте зиянды", "Қауіпті"],
        "en": ["Good", "Moderate", "Unhealthy for sensitive groups", "Unhealthy", "Very unhealthy", "Hazardous"],
    }
    bounds = [50, 100, 150, 200, 300]
    idx = 5
    for i, bound in enumerate(bounds):
        if aqi <= bound:
            idx = i
            break
    return levels.get(lang, levels["ru"])[idx]


def _localize_advice(aqi: int, lang: str) -> str:
    advice = {
        "ru": [
            "Можно проводить время на улице без ограничений.",
            "Для большинства людей воздух приемлем, но чувствительным группам лучше сократить длительные нагрузки.",
            "Детям, пожилым и людям с заболеваниями дыхательных путей лучше сократить время на улице.",
            "Рекомендуется ограничить активность на открытом воздухе и по возможности использовать маску.",
            "Лучше минимизировать пребывание на улице, держать окна закрытыми и использовать очиститель воздуха.",
        ],
        "kk": [
            "Сыртта шектеусіз жүруге болады.",
            "Көпшілік үшін ауа қалыпты, бірақ сезімтал топтарға ұзақ жүктемені азайтқан дұрыс.",
            "Балаларға, қарттарға және тыныс жолы аурулары бар адамдарға сыртта аз уақыт болған жөн.",
            "Ашық ауадағы белсенділікті шектеп, мүмкін болса маска қолдану ұсынылады.",
            "Сыртта болуды барынша азайтып, терезені жауып, ауа тазартқыш қолданған дұрыс.",
        ],
        "en": [
            "You can stay outdoors without restrictions.",
            "Air is acceptable for most people, but sensitive groups should reduce prolonged exertion.",
            "Children, older adults, and people with respiratory conditions should limit outdoor time.",
            "Limit outdoor activity and consider using a mask.",
            "Minimize outdoor exposure, keep windows closed, and use an air purifier if possible.",
        ],
    }
    if aqi <= 50:
        idx = 0
    elif aqi <= 100:
        idx = 1
    elif aqi <= 150:
        idx = 2
    elif aqi <= 200:
        idx = 3
    else:
        idx = 4
    return advice.get(lang, advice["ru"])[idx]


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
    q = _normalize_text(payload.question)
    lang = _detect_language(payload.question)
    if any(topic in q for topic in BLOCKED_TOPICS):
        return AssistantResponse(
            answer=_build_topic_guard_message(lang),
            region="n/a",
        )

    if not _is_weather_context(payload.question, lang):
        fallback = {
            "ru": "Я могу помочь с погодой и качеством воздуха. Например: 'погода в Алматы' или 'какой сейчас AQI в Шымкенте?'.",
            "kk": "Мен ауа райы мен ауа сапасы бойынша көмектесе аламын. Мысалы: 'Алматыдағы ауа райы' немесе 'Шымкенттегі AQI қандай?'.",
            "en": "I can help with weather and air quality. For example: 'weather in Almaty' or 'what is AQI in Shymkent now?'.",
        }
        return AssistantResponse(answer=fallback.get(lang, fallback["ru"]), region="n/a")

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
    aqi_level = _localize_aqi_level(aqi, lang)
    advice = _localize_advice(aqi, lang)
    fallback_answer = _build_assistant_answer(
        lang=lang,
        region_name=region_name,
        temp=temp,
        humidity=humidity,
        wind=wind,
        aqi=aqi,
        aqi_level=aqi_level,
        advice=advice,
    )
    llm_answer = await _try_llm_assistant_answer(
        question=payload.question,
        lang=lang,
        region_name=region_name,
        temp=temp,
        humidity=humidity,
        wind=wind,
        aqi=aqi,
        aqi_level=aqi_level,
        advice=advice,
    )
    answer = llm_answer or fallback_answer

    return AssistantResponse(answer=answer, region=region_name)
