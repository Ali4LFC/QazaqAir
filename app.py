from fastapi import FastAPI, HTTPException, Query
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, JSONResponse
import httpx
import uvicorn
import os
from dotenv import load_dotenv
from datetime import datetime, timedelta
from sqlalchemy import create_engine, Table, Column, Integer, String, Float, DateTime, MetaData, select, and_, inspect, func, UniqueConstraint, text
from sqlalchemy.engine import URL
from sqlalchemy.exc import SQLAlchemyError
from apscheduler.schedulers.background import BackgroundScheduler
import psycopg2
from psycopg2.extras import execute_values
from urllib.parse import urlparse, unquote

# Load environment variables from .env
load_dotenv(override=True)

app = FastAPI(title="Astana Air Quality Monitor")

# --- Config ---
WAQI_TOKEN = os.getenv("WAQI_TOKEN", "")
CITY = "Astana"
POSTGRES_URL = os.getenv("POSTGRES_URL", "")

REGIONS = [
    {"key": "astana", "name": "Астана", "city": "Astana", "coords": [51.1694, 71.4491], "aliases": ["Nur-Sultan"]},
    {"key": "almaty_city", "name": "Алматы", "city": "Almaty", "coords": [43.2383, 76.9453], "aliases": []},
    {"key": "shymkent", "name": "Шымкент", "city": "Shymkent", "coords": [42.3417, 69.5901], "aliases": []},
    {"key": "akmola", "name": "Акмолинская область", "city": "Kokshetau", "coords": [53.2833, 69.3833], "aliases": ["Kokchetav"]},
    {"key": "aktobe", "name": "Актюбинская область", "city": "Aktobe", "coords": [50.2833, 57.1667], "aliases": ["Aktyubinsk"]},
    {"key": "almaty_obl", "name": "Алматинская область", "city": "Taldykorgan", "coords": [45.0167, 78.3667], "aliases": []},
    {"key": "atyrau", "name": "Атырауская область", "city": "Atyrau", "coords": [47.1167, 51.8833], "aliases": ["Guryev"]},
    {"key": "east_kz", "name": "Восточно-Казахстанская область", "city": "Oskemen", "coords": [49.9667, 82.6167], "aliases": ["Ust-Kamenogorsk"]},
    {"key": "zhambyl", "name": "Жамбылская область", "city": "Taraz", "coords": [42.9000, 71.3667], "aliases": ["Dzhambul"]},
    {"key": "west_kz", "name": "Западно-Казахстанская область", "city": "Oral", "coords": [51.2225, 51.3866], "aliases": ["Uralsk"]},
    {"key": "karaganda", "name": "Карагандинская область", "city": "Karaganda", "coords": [49.8047, 73.1094], "aliases": ["Karagandy"]},
    {"key": "kostanay", "name": "Костанайская область", "city": "Kostanay", "coords": [53.2144, 63.6246], "aliases": ["Kustanay"]},
    {"key": "kyzylorda", "name": "Кызылординская область", "city": "Kyzylorda", "coords": [44.8500, 65.5000], "aliases": ["Kyzyl-Orda"]},
    {"key": "mangystau", "name": "Мангистауская область", "city": "Aktau", "coords": [43.6500, 51.1667], "aliases": []},
    {"key": "north_kz", "name": "Северо-Казахстанская область", "city": "Petropavl", "coords": [54.8667, 69.1500], "aliases": ["Petropavlovsk"]},
    {"key": "pavlodar", "name": "Павлодарская область", "city": "Pavlodar", "coords": [52.3000, 76.9500], "aliases": []},
    {"key": "turkistan", "name": "Туркестанская область", "city": "Turkistan", "coords": [43.3000, 68.2667], "aliases": []},
    {"key": "abay", "name": "Абайская область", "city": "Semey", "coords": [50.4333, 80.2667], "aliases": ["Semipalatinsk"]},
    {"key": "ulytau", "name": "Улытауская область", "city": "Zhezkazgan", "coords": [47.7833, 67.7000], "aliases": ["Zhezqazghan"]},
    {"key": "jetisu", "name": "Жетысуская область", "city": "Taldykorgan", "coords": [45.0167, 78.3667], "aliases": []},
]

cache = {"regions": {}}
db = {"engine": None, "table": None}
scheduler = BackgroundScheduler()

def _cache_get(key: str):
    item = cache["regions"].get(key)
    if not item:
        return None
    now = datetime.now()
    if item["last_updated"] and (now - item["last_updated"]) < timedelta(seconds=30):
        return item["data"]
    return None

def _cache_set(key: str, data: dict):
    cache["regions"][key] = {"data": data, "last_updated": datetime.now()}

def _region_by_key_or_name(value: str):
    v = value.lower()
    for r in REGIONS:
        if r["key"] == v or r["name"].lower() == v or r["city"].lower() == v:
            return r
    return None
 
async def _fetch_for_region(r: dict):
    names = [r["city"]] + r.get("aliases", [])
    last_exc = None
    for nm in names:
        try:
            return await _fetch_city_data(nm, coords=r["coords"], name_hint=r["name"], prefer_geo=True)
        except HTTPException as e:
            last_exc = e
            continue
        except Exception as e:
            last_exc = e
            continue
    return {
        "city": r["city"],
        "region": {"key": r["key"], "name": r["name"], "coords": r["coords"]},
        "location": {"type": "Point", "coordinates": [r["coords"][1], r["coords"][0]]},
        "current": {
            "pollution": {"aqius": None, "pm25": None},
            "weather": {"tp": 0, "hu": 0, "ws": 0},
        },
        "error": "WAQI API unavailable for this region",
    }

async def _fetch_city_data(city: str, coords: list[float] | None = None, name_hint: str | None = None, prefer_geo: bool = False):
    if not WAQI_TOKEN:
        raise HTTPException(status_code=500, detail="WAQI Token not configured in .env file")
    async with httpx.AsyncClient(timeout=15.0) as client:
        if prefer_geo and coords:
            g_url = f"https://api.waqi.info/feed/geo:{coords[0]};{coords[1]}/?token={WAQI_TOKEN}"
            gr = await client.get(g_url)
            g_raw = gr.json()
            if g_raw.get("status") == "ok":
                d = g_raw["data"]
                return {
                    "city": name_hint or city,
                    "location": {"type": "Point", "coordinates": [coords[1], coords[0]]},
                    "current": {
                        "pollution": {"aqius": d["aqi"], "pm25": d.get("iaqi", {}).get("pm25", d.get("iaqi", {}).get("p2", {})).get("v", None)},
                        "weather": {
                            "tp": d.get("iaqi", {}).get("t", {}).get("v", 0),
                            "hu": d.get("iaqi", {}).get("h", {}).get("v", 0),
                            "ws": d.get("iaqi", {}).get("w", {}).get("v", 0),
                        },
                    },
                }
        url = f"https://api.waqi.info/feed/{city}/?token={WAQI_TOKEN}"
        r = await client.get(url)
        raw = r.json()
        if raw.get("status") == "ok":
            d = raw["data"]
            return {
                "city": city,
                "location": {"type": "Point", "coordinates": [d["city"]["geo"][1], d["city"]["geo"][0]]},
                "current": {
                    "pollution": {"aqius": d["aqi"], "pm25": d.get("iaqi", {}).get("pm25", d.get("iaqi", {}).get("p2", {})).get("v", None)},
                    "weather": {
                        "tp": d.get("iaqi", {}).get("t", {}).get("v", 0),
                        "hu": d.get("iaqi", {}).get("h", {}).get("v", 0),
                        "ws": d.get("iaqi", {}).get("w", {}).get("v", 0),
                    },
                },
            }
        if coords and not prefer_geo:
            g_url = f"https://api.waqi.info/feed/geo:{coords[0]};{coords[1]}/?token={WAQI_TOKEN}"
            gr = await client.get(g_url)
            g_raw = gr.json()
            if g_raw.get("status") == "ok":
                d = g_raw["data"]
                return {
                    "city": name_hint or city,
                    "location": {"type": "Point", "coordinates": [coords[1], coords[0]]},
                    "current": {
                        "pollution": {"aqius": d["aqi"], "pm25": d.get("iaqi", {}).get("pm25", d.get("iaqi", {}).get("p2", {})).get("v", None)},
                        "weather": {
                            "tp": d.get("iaqi", {}).get("t", {}).get("v", 0),
                            "hu": d.get("iaqi", {}).get("h", {}).get("v", 0),
                            "ws": d.get("iaqi", {}).get("w", {}).get("v", 0),
                        },
                    },
                }
        kw = name_hint or city
        s_url = f"https://api.waqi.info/search/?token={WAQI_TOKEN}&keyword={kw}"
        s = await client.get(s_url)
        s_raw = s.json()
        if s_raw.get("status") != "ok" or not s_raw.get("data"):
            raise HTTPException(status_code=502, detail="WAQI API error")
        top = s_raw["data"][0]
        geo = top.get("station", {}).get("geo", [None, None])
        return {
            "city": top.get("station", {}).get("name", kw),
            "location": {"type": "Point", "coordinates": [geo[1], geo[0]]},
            "current": {
                "pollution": {"aqius": int(top.get("aqi", 0)), "pm25": None},
                "weather": {"tp": 0, "hu": 0, "ws": 0},
            },
        }

@app.get("/api/air-quality")
async def get_air_quality(region: str | None = Query(default=None)):
    try:
        if region:
            r = _region_by_key_or_name(region)
            if not r:
                raise HTTPException(status_code=404, detail="Region not found")
            cached = _cache_get(r["key"])
            if cached:
                return cached
            data = await _fetch_for_region(r)
            data["region"] = {"key": r["key"], "name": r["name"], "coords": r["coords"]}
            _cache_set(r["key"], data)
            return data
        cached = _cache_get(CITY.lower())
        if cached:
            return cached
        data = await _fetch_city_data(CITY)
        _cache_set(CITY.lower(), data)
        return data
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Request failed: {str(e)}")


@app.get("/api/debug")
async def debug_info():
    """Debug endpoint: shows config status"""
    return {
        "token_set": bool(WAQI_TOKEN),
        "token_prefix": WAQI_TOKEN[:8] + "..." if WAQI_TOKEN else "NOT SET",
        "city": CITY,
        "regions_cached": list(cache["regions"].keys()),
    }

@app.get("/api/regions")
async def get_regions():
    return [{"key": r["key"], "name": r["name"], "city": r["city"], "coords": r["coords"]} for r in REGIONS]

@app.get("/api/summary")
async def get_summary():
    results = []
    try:
        async with httpx.AsyncClient(timeout=15.0) as client:
            for r in REGIONS:
                c = _cache_get(r["key"])
                if c:
                    aq = c["current"]["pollution"]["aqius"]
                    results.append({"region": r["name"], "key": r["key"], "aqi": aq})
                    continue
                try:
                    d = await _fetch_for_region(r)
                    aq = int(d["current"]["pollution"]["aqius"])
                    results.append({"region": r["name"], "key": r["key"], "aqi": aq})
                    _cache_set(r["key"], d)
                except Exception:
                    results.append({"region": r["name"], "key": r["key"], "aqi": None})
    except Exception:
        pass
    clean = [x for x in results if isinstance(x["aqi"], int)]
    clean_sorted = sorted(clean, key=lambda x: x["aqi"])
    dirty_sorted = list(reversed(clean_sorted))
    return {"clean": clean_sorted[:10], "dirty": dirty_sorted[:10]}

def _init_db():
    if not POSTGRES_URL:
        print("[DB ERROR] POSTGRES_URL не установлен в .env")
        return
    try:
        # Разбираем URL для надежной передачи параметров
        u = urlparse(POSTGRES_URL)
        username = unquote(u.username) if u.username else None
        password = unquote(u.password) if u.password else None
        
        # Маскированный URL для логов (без пароля)
        print(f"[DB DEBUG] Пытаюсь подключиться к: {u.hostname}")
        print(f"[DB DEBUG] Пользователь: {username}")
        if password:
            print(f"[DB DEBUG] Длина пароля: {len(password)} символов")

        # Создаем engine через объект URL, чтобы избежать проблем с парсингом строки внутри SQLAlchemy
        db_url = URL.create(
            drivername="postgresql+psycopg2",
            username=username,
            password=password,
            host=u.hostname,
            port=u.port or 5432,
            database=(u.path or "").lstrip("/"),
        )
        
        engine = create_engine(db_url, pool_pre_ping=True, future=True)
        meta = MetaData()
        table = Table(
            "aqi_hourly",
            meta,
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
        meta.create_all(engine)
        db["engine"] = engine
        db["table"] = table
        print("[DB] Connection initialized and tables checked.")
    except Exception as e:
        print(f"[DB ERROR] Failed to initialize DB: {e}")
        db["engine"] = None
        db["table"] = None

def _save_hourly_row(conn, rkey: str, city: str, ts_hour: datetime, aqi, tp, hu, ws):
    sql = text("""
        INSERT INTO aqi_hourly (region_key, city, ts_hour, aqi, temp_c, humidity_pct, wind_ms)
        VALUES (:region_key, :city, :ts_hour, :aqi, :temp_c, :humidity_pct, :wind_ms)
        ON CONFLICT (region_key, ts_hour) DO NOTHING
    """)
    conn.execute(sql, {
        "region_key": rkey,
        "city": city,
        "ts_hour": ts_hour,
        "aqi": aqi,
        "temp_c": tp,
        "humidity_pct": hu,
        "wind_ms": ws,
    })

def _save_all_regions_now():
    if not POSTGRES_URL:
        return {"ok": False, "reason": "DB not configured"}
    ts_hour = datetime.utcnow().replace(minute=0, second=0, microsecond=0)
    try:
        u = urlparse(POSTGRES_URL)
        dbname = (u.path or "").lstrip("/")
        conn = psycopg2.connect(
            dbname=dbname,
            user=unquote(u.username) if u.username else None,
            password=unquote(u.password) if u.password else None,
            host=u.hostname,
            port=u.port or 5432,
        )
        conn.autocommit = True
        cur = conn.cursor()
        rows = []
        for r in REGIONS:
            try:
                data = _cache_get(r["key"]) or None
                if not data:
                    data = _fetch_for_region_sync(r)
                aqi = data["current"]["pollution"]["aqius"]
                tp = data["current"]["weather"]["tp"]
                hu = data["current"]["weather"]["hu"]
                ws = data["current"]["weather"]["ws"]
                rows.append((r["key"], data.get("city", r["city"]), ts_hour, aqi, tp, hu, ws))
            except Exception:
                continue
        if rows:
            sql = """
                INSERT INTO aqi_hourly (region_key, city, ts_hour, aqi, temp_c, humidity_pct, wind_ms)
                VALUES %s
                ON CONFLICT (region_key, ts_hour) DO NOTHING
            """
            execute_values(cur, sql, rows)
        cur.close()
        conn.close()
    except Exception as e:
        return {"ok": False, "reason": str(e)}
    return {"ok": True}

def _fetch_for_region_sync(r: dict):
    if not WAQI_TOKEN:
        raise HTTPException(status_code=500, detail="WAQI Token not configured in .env file")
    names = [r["city"]] + r.get("aliases", [])
    for nm in names:
        try:
            url = f"https://api.waqi.info/feed/{nm}/?token={WAQI_TOKEN}"
            resp = httpx.get(url, timeout=15.0)
            raw = resp.json()
            if raw.get("status") == "ok":
                d = raw["data"]
                return {
                    "city": nm,
                    "location": {"type": "Point", "coordinates": [d["city"]["geo"][1], d["city"]["geo"][0]]},
                    "current": {
                        "pollution": {"aqius": d["aqi"]},
                        "weather": {
                            "tp": d.get("iaqi", {}).get("t", {}).get("v", 0),
                            "hu": d.get("iaqi", {}).get("h", {}).get("v", 0),
                            "ws": d.get("iaqi", {}).get("w", {}).get("v", 0),
                        },
                    },
                }
        except Exception:
            continue
    try:
        g_url = f"https://api.waqi.info/feed/geo:{r['coords'][0]};{r['coords'][1]}/?token={WAQI_TOKEN}"
        gr = httpx.get(g_url, timeout=15.0)
        g_raw = gr.json()
        if g_raw.get("status") == "ok":
            d = g_raw["data"]
            return {
                "city": r["name"],
                "location": {"type": "Point", "coordinates": [d["city"]["geo"][1], d["city"]["geo"][0]]},
                "current": {
                    "pollution": {"aqius": d["aqi"]},
                    "weather": {
                        "tp": d.get("iaqi", {}).get("t", {}).get("v", 0),
                        "hu": d.get("iaqi", {}).get("h", {}).get("v", 0),
                        "ws": d.get("iaqi", {}).get("w", {}).get("v", 0),
                    },
                },
            }
    except Exception:
        pass
    return {
        "city": r["city"],
        "location": {"type": "Point", "coordinates": [r["coords"][1], r["coords"][0]]},
        "current": {
            "pollution": {"aqius": None},
            "weather": {"tp": 0, "hu": 0, "ws": 0},
        },
    }

@app.on_event("startup")
async def on_startup():
    try:
        _init_db()
    except Exception as e:
        print(f"[STARTUP ERROR] Инициализация БД провалилась, но приложение продолжит работу: {e}")

    if db["engine"]:
        # Сразу сохраняем один раз при запуске
        print("[DB] Выполняю немедленное сохранение данных при запуске...")
        res = _save_all_regions_now()
        if res.get("ok"):
            print("[DB] Первое сохранение данных прошло успешно!")
        else:
            print(f"[DB ERROR] Не удалось сохранить данные при запуске: {res.get('reason')}")

        scheduler.add_job(_save_all_regions_now, "cron", minute=0)
        scheduler.start()
    else:
        print("[WARNING] Движок БД недоступен. Фоновое сохранение НЕ запущено.")

@app.on_event("shutdown")
async def on_shutdown():
    try:
        scheduler.shutdown(wait=False)
    except Exception:
        pass

@app.post("/api/save-hourly")
async def save_hourly():
    try:
        result = _save_all_regions_now()
        return result
    except Exception as e:
        return JSONResponse(status_code=200, content={"ok": False, "reason": str(e)})

@app.get("/api/db-status")
async def db_status():
    configured = bool(POSTGRES_URL)
    connected = False
    table_exists = False
    err = None
    try:
        if db["engine"]:
            with db["engine"].connect() as conn:
                conn.execute(select(1))
                connected = True
            inspector = inspect(db["engine"])
            table_exists = inspector.has_table("aqi_hourly", schema="public")
    except SQLAlchemyError as e:
        err = str(e)
    except Exception as e:
        err = str(e)
    url_prefix = POSTGRES_URL.split("@")[0] + "@..." if POSTGRES_URL else None
    return {
        "configured": configured,
        "connected": connected,
        "table_exists": table_exists,
        "url": url_prefix,
        "error": err
    }


app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
async def read_index():
    return FileResponse("static/index.html")


if __name__ == "__main__":
    print("=" * 50)
    print(" Astana Air Monitor starting (WAQI mode)...")
    print(f" Token: {'SET (' + WAQI_TOKEN[:8] + '...)' if WAQI_TOKEN else 'NOT SET!'}")
    print(f" Open: http://127.0.0.1:8000")
    print("=" * 50)
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=False)
