import os
import shutil
import subprocess
from datetime import datetime
from pathlib import Path
from app.core.config import settings

class BackupService:
    def __init__(self, backup_dir: str = settings.BACKUP_DIR):
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(parents=True, exist_ok=True)

    def run_backup(self):
        if not settings.POSTGRES_URL:
            print("[Backup] POSTGRES_URL not configured. Skipping.")
            return None

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"backup_{timestamp}.sql"
        filepath = self.backup_dir / filename

        # В PostgreSQL URL может быть закодирован пароль и т.д.
        # pg_dump обычно требует пароль либо в .pgpass, либо в PGPASSWORD
        # Попробуем извлечь пароль из URL для PGPASSWORD
        try:
            from urllib.parse import urlparse, unquote
            u = urlparse(settings.POSTGRES_URL)
            env = os.environ.copy()
            if u.password:
                env["PGPASSWORD"] = unquote(u.password)
            
            # Попытка найти pg_dump в PATH
            pg_dump_cmd = shutil.which("pg_dump")
            # Если в PATH не найден, проверяем типовые пути
            if not pg_dump_cmd:
                possible_paths = []
                # Windows-пути
                possible_paths.extend([
                    r"C:\Program Files\PostgreSQL\18\bin\pg_dump.exe",
                    r"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe",
                    r"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
                ])
                # Linux-пути
                possible_paths.extend([
                    "/usr/bin/pg_dump",
                    "/usr/local/bin/pg_dump",
                ])
                for p in possible_paths:
                    if os.path.exists(p):
                        pg_dump_cmd = p
                        break
            if not pg_dump_cmd:
                print("[Backup] pg_dump not found in PATH or known locations.")
                return None

            command = [
                pg_dump_cmd,
                "-h", u.hostname or "localhost",
                "-p", str(u.port or 5432),
                "-U", unquote(u.username or "postgres"),
                "-f", str(filepath),
                (u.path or "").lstrip("/")
            ]

            print(f"[Backup] Starting backup to {filepath}...")
            result = subprocess.run(command, env=env, capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"[Backup] Success: {filename}")
                return str(filepath)
            else:
                print(f"[Backup] Failed: {result.stderr}")
                return None
        except Exception as e:
            print(f"[Backup] Error during backup: {e}")
            return None

backup_service = BackupService()
