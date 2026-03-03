import httpx
from fastapi import HTTPException
from datetime import datetime, timedelta
from backend.app.core.config import settings

class WAQIService:
    def __init__(self):
        self.cache = {"regions": {}}

    def _cache_get(self, key: str):
        item = self.cache["regions"].get(key)
        if not item:
            return None
        now = datetime.now()
        if item["last_updated"] and (now - item["last_updated"]) < timedelta(seconds=60):
            return item["data"]
        return None

    def _cache_set(self, key: str, data: dict):
        self.cache["regions"][key] = {"data": data, "last_updated": datetime.now()}

    def get_region_by_key_or_name(self, value: str):
        v = value.lower()
        for r in settings.REGIONS:
            if r["key"] == v or r["name"].lower() == v or r["city"].lower() == v:
                return r
        return None

    async def fetch_for_region(self, r: dict):
        names = [r["city"]] + r.get("aliases", [])
        for nm in names:
            try:
                # В name_hint передаем казахское название для сохранения в БД
                res = await self.fetch_city_data(nm, coords=r["coords"], name_hint=r.get("name_kk", r["name"]), prefer_geo=True)
                return res
            except Exception:
                continue
        return {
            "city": r["city"],
            "region": {"key": r["key"], "name": r["name"], "name_kk": r.get("name_kk"), "coords": r["coords"]},
            "location": {"type": "Point", "coordinates": [r["coords"][1], r["coords"][0]]},
            "current": {
                "pollution": {"aqius": None, "pm25": None},
                "weather": {"tp": 0, "hu": 0, "ws": 0},
            },
            "error": "WAQI API unavailable for this region",
        }

    async def fetch_city_data(self, city: str, coords: list[float] | None = None, name_hint: str | None = None, prefer_geo: bool = False):
        if not settings.WAQI_TOKEN:
            raise HTTPException(status_code=500, detail="WAQI Token not configured in .env file")
        
        async with httpx.AsyncClient(timeout=15.0) as client:
            if prefer_geo and coords:
                g_url = f"https://api.waqi.info/feed/geo:{coords[0]};{coords[1]}/?token={settings.WAQI_TOKEN}"
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
            
            url = f"https://api.waqi.info/feed/{city}/?token={settings.WAQI_TOKEN}"
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
            
            # Additional fallback logic (search)
            kw = name_hint or city
            s_url = f"https://api.waqi.info/search/?token={settings.WAQI_TOKEN}&keyword={kw}"
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

    def fetch_for_region_sync(self, r: dict):
        if not settings.WAQI_TOKEN:
            return None
        names = [r["city"]] + r.get("aliases", [])
        for nm in names:
            try:
                url = f"https://api.waqi.info/feed/{nm}/?token={settings.WAQI_TOKEN}"
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
        return None

waqi_service = WAQIService()
