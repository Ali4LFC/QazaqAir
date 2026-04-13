-- ============================================================
-- QazaqAir Database Schema for Supabase (PostgreSQL)
-- СОВМЕСТИМА С SQLAlchemy (backend/app/db/session.py)
-- ============================================================

-- ============================================================
-- 1. USERS TABLE (Существующая структура из твоего session.py)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    city_key VARCHAR(64),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================================
-- 2. AQI HOURLY TABLE (Как в твоём session.py)
-- ============================================================
CREATE TABLE IF NOT EXISTS aqi_hourly (
    id SERIAL PRIMARY KEY,
    region_key VARCHAR(64) NOT NULL,
    city VARCHAR(128) NOT NULL,
    ts_hour TIMESTAMP NOT NULL,
    aqi INTEGER,
    temp_c FLOAT,
    humidity_pct INTEGER,
    wind_ms FLOAT,
    
    CONSTRAINT uq_region_hour UNIQUE (region_key, ts_hour)
);

CREATE INDEX IF NOT EXISTS idx_aqi_hourly_region_key ON aqi_hourly(region_key);
CREATE INDEX IF NOT EXISTS idx_aqi_hourly_ts_hour ON aqi_hourly(ts_hour);

-- ============================================================
-- 3. REGIONS TABLE (Дополнительно - справочник регионов)
-- ============================================================
CREATE TABLE IF NOT EXISTS regions (
    id SERIAL PRIMARY KEY,
    key VARCHAR(64) UNIQUE NOT NULL,
    name VARCHAR(128) NOT NULL,
    name_kk VARCHAR(128),
    city VARCHAR(128),
    coords_lat FLOAT,
    coords_lon FLOAT,
    country VARCHAR(50) DEFAULT 'Kazakhstan'
);

-- Заполнение регионов Казахстана
INSERT INTO regions (key, name, name_kk, city, coords_lat, coords_lon) VALUES
('astana', 'Астана', 'Астана', 'Astana', 51.1694, 71.4491),
('almaty_city', 'Алматы', 'Алматы', 'Almaty', 43.2383, 76.9453),
('shymkent', 'Шымкент', 'Шымкент', 'Shymkent', 42.3417, 69.5901),
('akmola', 'Акмолинская область', 'Ақмола облысы', 'Kokshetau', 53.2833, 69.3833),
('aktobe', 'Актюбинская область', 'Ақтөбе облысы', 'Aktobe', 50.2833, 57.1667),
('almaty_obl', 'Алматинская область', 'Алматы облысы', 'Taldykorgan', 45.0167, 78.3667),
('atyrau', 'Атырауская область', 'Атырау облысы', 'Atyrau', 47.1167, 51.8833),
('east_kz', 'Восточно-Казахстанская область', 'Шығыс Қазақстан облысы', 'Oskemen', 49.9667, 82.6167),
('zhambyl', 'Жамбылская область', 'Жамбыл облысы', 'Taraz', 42.9000, 71.3667),
('west_kz', 'Западно-Казахстанская область', 'Батыс Қазақстан облысы', 'Oral', 51.2225, 51.3866),
('karaganda', 'Карагандинская область', 'Қарағанды облысы', 'Karaganda', 49.8047, 73.1094),
('kostanay', 'Костанайская область', 'Қостанай облысы', 'Kostanay', 53.2144, 63.6246),
('kyzylorda', 'Кызылординская область', 'Қызылорда облысы', 'Kyzylorda', 44.8500, 65.5000),
('mangystau', 'Мангистауская область', 'Маңғыстау облысы', 'Aktau', 43.6500, 51.1667),
('north_kz', 'Северо-Казахстанская область', 'Солтүстік Қазақстан облысы', 'Petropavl', 54.8667, 69.1500),
('pavlodar', 'Павлодарская область', 'Павлодар облысы', 'Pavlodar', 52.3000, 76.9500),
('turkistan', 'Туркестанская область', 'Түркістан облысы', 'Turkistan', 43.3000, 68.2667),
('abay', 'Абайская область', 'Абай облысы', 'Semey', 50.4333, 80.2667),
('ulytau', 'Улытауская область', 'Ұлытау облысы', 'Zhezkazgan', 47.7833, 67.7000),
('jetisu', 'Жетысуская область', 'Жетісу облысы', 'Taldykorgan', 45.0167, 78.3667)
ON CONFLICT (key) DO NOTHING;

-- ============================================================
-- 4. USER FAVORITES (Избранные регионы)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    region_key VARCHAR(64) NOT NULL REFERENCES regions(key) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, region_key)
);

CREATE INDEX IF NOT EXISTS idx_favorites_user ON user_favorites(user_id);

-- ============================================================
-- 5. USER SETTINGS (Настройки: язык, тема)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_settings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    language VARCHAR(5) DEFAULT 'ru',
    theme VARCHAR(10) DEFAULT 'dark',
    notifications_enabled BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ============================================================
-- RLS POLICIES (Для совместимости с Supabase)
-- ============================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE aqi_hourly ENABLE ROW LEVEL SECURITY;
ALTER TABLE regions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "AQI data public" ON aqi_hourly FOR SELECT USING (true);
CREATE POLICY "Regions public" ON regions FOR SELECT USING (true);
CREATE POLICY "Users access" ON users FOR ALL USING (true);
CREATE POLICY "Favorites access" ON user_favorites FOR ALL USING (true);
CREATE POLICY "Settings access" ON user_settings FOR ALL USING (true);

-- ============================================================
-- END
-- ============================================================
