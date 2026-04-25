import os
from pathlib import Path
from dotenv import load_dotenv

# Путь к файлу .env в папке backend
# __file__ это backend/app/core/config.py
# .parent это backend/app/core/
# .parent.parent это backend/app/
# .parent.parent.parent это backend/
env_path = Path(__file__).resolve().parent.parent.parent / ".env"
load_dotenv(dotenv_path=env_path, override=True)

class Settings:
    PROJECT_NAME: str = "QazaqAir"
    WAQI_TOKEN: str = os.getenv("WAQI_TOKEN", "")
    CITY: str = "Astana"
    POSTGRES_URL: str = os.getenv("POSTGRES_URL", "")
    RATE_LIMIT_WINDOW_SECONDS: int = int(os.getenv("RATE_LIMIT_WINDOW_SECONDS", "60"))
    RATE_LIMIT_MAX_REQUESTS: int = int(os.getenv("RATE_LIMIT_MAX_REQUESTS", "60"))
    ALLOWED_IPS: list[str] = [x.strip() for x in os.getenv("ALLOWED_IPS", "").split(",") if x.strip()]
    BLOCKED_IPS: list[str] = [x.strip() for x in os.getenv("BLOCKED_IPS", "").split(",") if x.strip()]
    TRUST_X_FORWARDED: bool = os.getenv("TRUST_X_FORWARDED", "false").lower() in ("1", "true", "yes", "y")
    SSL_CERTFILE: str | None = os.getenv("SSL_CERTFILE") or None
    SSL_KEYFILE: str | None = os.getenv("SSL_KEYFILE") or None
    
    BACKUP_DIR: str = os.getenv("BACKUP_DIR", "backups")
    SSH_ENABLED: bool = os.getenv("SSH_ENABLED", "false").lower() in ("1", "true", "yes", "y")
    SSH_PORT: int = int(os.getenv("SSH_PORT", "2222"))
    SSH_USER: str = os.getenv("SSH_USER", "admin")
    SSH_PASS: str = os.getenv("SSH_PASS", "admin123")
    
    SECRET_KEY: str = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
    OPENAI_API_KEY: str = os.getenv("OPENAI_API_KEY", "")
    OPENAI_API_BASE: str = os.getenv("OPENAI_API_BASE", "https://api.openai.com/v1")
    AI_MODEL: str = os.getenv("AI_MODEL", "gpt-3.5-turbo")
    
    REGIONS = [
        {"key": "astana", "name": "Астана", "name_kk": "Астана", "city": "Astana", "coords": [51.1694, 71.4491], "aliases": ["Nur-Sultan"]},
        {"key": "almaty_city", "name": "Алматы", "name_kk": "Алматы", "city": "Almaty", "coords": [43.2383, 76.9453], "aliases": []},
        {"key": "shymkent", "name": "Шымкент", "name_kk": "Шымкент", "city": "Shymkent", "coords": [42.3417, 69.5901], "aliases": []},
        {"key": "akmola", "name": "Акмолинская область", "name_kk": "Ақмола облысы", "city": "Kokshetau", "coords": [53.2833, 69.3833], "aliases": ["Kokchetav"]},
        {"key": "aktobe", "name": "Актюбинская область", "name_kk": "Ақтөбе облысы", "city": "Aktobe", "coords": [50.2833, 57.1667], "aliases": ["Aktyubinsk"]},
        {"key": "almaty_obl", "name": "Алматинская область", "name_kk": "Алматы облысы", "city": "Taldykorgan", "coords": [45.0167, 78.3667], "aliases": []},
        {"key": "atyrau", "name": "Атырауская область", "name_kk": "Атырау облысы", "city": "Atyrau", "coords": [47.1167, 51.8833], "aliases": ["Guryev"]},
        {"key": "east_kz", "name": "Восточно-Казахстанская область", "name_kk": "Шығыс Қазақстан облысы", "city": "Oskemen", "coords": [49.9667, 82.6167], "aliases": ["Ust-Kamenogorsk"]},
        {"key": "zhambyl", "name": "Жамбылская область", "name_kk": "Жамбыл облысы", "city": "Taraz", "coords": [42.9000, 71.3667], "aliases": ["Dzhambul"]},
        {"key": "west_kz", "name": "Западно-Казахстанская область", "name_kk": "Батыс Қазақстан облысы", "city": "Oral", "coords": [51.2225, 51.3866], "aliases": ["Uralsk"]},
        {"key": "karaganda", "name": "Карагандинская область", "name_kk": "Қарағанды облысы", "city": "Karaganda", "coords": [49.8047, 73.1094], "aliases": ["Karagandy"]},
        {"key": "kostanay", "name": "Костанайская область", "name_kk": "Қостанай облысы", "city": "Kostanay", "coords": [53.2144, 63.6246], "aliases": ["Kustanay"]},
        {"key": "kyzylorda", "name": "Кызылординская область", "name_kk": "Қызылорда облысы", "city": "Kyzylorda", "coords": [44.8500, 65.5000], "aliases": ["Kyzyl-Orda"]},
        {"key": "mangystau", "name": "Мангистауская область", "name_kk": "Маңғыстау облысы", "city": "Aktau", "coords": [43.6500, 51.1667], "aliases": []},
        {"key": "north_kz", "name": "Северо-Казахстанская область", "name_kk": "Солтүстік Қазақстан облысы", "city": "Petropavl", "coords": [54.8667, 69.1500], "aliases": ["Petropavlovsk"]},
        {"key": "pavlodar", "name": "Павлодарская область", "name_kk": "Павлодар облысы", "city": "Pavlodar", "coords": [52.3000, 76.9500], "aliases": []},
        {"key": "turkistan", "name": "Туркестанская область", "name_kk": "Түркістан облысы", "city": "Turkistan", "coords": [43.3000, 68.2667], "aliases": []},
        {"key": "abay", "name": "Абайская область", "name_kk": "Абай облысы", "city": "Semey", "coords": [50.4333, 80.2667], "aliases": ["Semipalatinsk"]},
        {"key": "ulytau", "name": "Улытауская область", "name_kk": "Ұлытау облысы", "city": "Zhezkazgan", "coords": [47.7833, 67.7000], "aliases": ["Zhezqazghan"]},
        {"key": "jetisu", "name": "Жетысуская область", "name_kk": "Жетісу облысы", "city": "Taldykorgan", "coords": [45.0167, 78.3667], "aliases": ["Жетісу", "Жетысу", "Jetisu", "Zhetisu"]},
    ]

settings = Settings()
