import httpx
from datetime import datetime, timedelta
import psycopg2
from psycopg2.extras import execute_values
from urllib.parse import urlparse, unquote
from apscheduler.schedulers.background import BackgroundScheduler
from backend.app.core.config import settings
from backend.app.db.session import db
from backend.app.services.waqi_service import waqi_service

class SchedulerService:
    def __init__(self):
        self.scheduler = BackgroundScheduler()

    def save_all_regions_now(self):
        if not settings.POSTGRES_URL:
            return {"ok": False, "reason": "DB not configured"}
        
        kz_time = datetime.utcnow() + timedelta(hours=5)
        ts_hour = kz_time.replace(microsecond=0)
        
        try:
            u = urlparse(settings.POSTGRES_URL)
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
            for r in settings.REGIONS:
                try:
                    data = waqi_service._cache_get(r["key"])
                    if not data:
                        data = waqi_service.fetch_for_region_sync(r)
                    if not data:
                        continue
                        
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

    def start(self):
        if db.engine:
            self.scheduler.start()
            # First run after 1 minute
            run_at = datetime.now() + timedelta(minutes=1)
            self.scheduler.add_job(self.save_all_regions_now, 'date', run_date=run_at)
            # Hourly cron
            self.scheduler.add_job(self.save_all_regions_now, "cron", minute=0)
            print("[Scheduler] Started.")
        else:
            print("[Scheduler WARNING] DB engine not available. Background tasks NOT started.")

    def shutdown(self):
        self.scheduler.shutdown(wait=False)

scheduler_service = SchedulerService()
