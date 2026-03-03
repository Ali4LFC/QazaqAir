const ASTANA_COORDS = [51.1694, 71.4491];
let selectedRegion = null;
let currentTheme = localStorage.getItem('theme') || 'dark';
let currentLang = localStorage.getItem('lang') || 'kk';

const TRANSLATIONS = {
    kk: {
        good: "Жақсы",
        moderate: "Орташа",
        sensitive: "Сезімтал топтар үшін зиянды",
        unhealthy: "Зиянды",
        veryUnhealthy: "Өте зиянды",
        hazardous: "Қауіпті",
        noData: "Мәлімет жоқ",
        loading: "Жүктелуде...",
        error: "Қате орын алды",
        updateTime: "Жаңартылды",
        temp: "Температура",
        hum: "Ылғалдылық",
        wind: "Жел",
        ms: "м/с",
        selectRegion: "Аймақты таңдаңыз",
        aqiCaption: "Ауа сапасының индексі (AQI)",
        regionsTitle: "Қазақстан аймақтары",
        searchPlaceholder: "Аймақты іздеу...",
        regionInfoTitle: "Аймақ бойынша ақпарат",
        dirtyTitle: "Ең лас (топ-10)",
        cleanTitle: "Ең таза (топ-10)",
        footer: "Мәліметтер IQAir API арқылы алынды • Әр 60 секунд сайын жаңартылады.",
        status: "Мәртебесі"
    },
    ru: {
        good: "Хорошо",
        moderate: "Умеренно",
        sensitive: "Нездорово для чувствительных",
        unhealthy: "Нездорово",
        veryUnhealthy: "Очень нездорово",
        hazardous: "Опасно",
        noData: "Нет данных",
        loading: "Загрузка...",
        error: "Ошибка загрузки",
        updateTime: "Обновлено",
        temp: "Температура",
        hum: "Влажность",
        wind: "Ветер",
        ms: "м/с",
        selectRegion: "Выберите регион",
        aqiCaption: "Индекс качества воздуха (AQI)",
        regionsTitle: "Регионы Казахстана",
        searchPlaceholder: "Поиск региона...",
        regionInfoTitle: "Информация по региону",
        dirtyTitle: "Самые загрязненные (топ‑10)",
        cleanTitle: "Самые чистые (топ‑10)",
        footer: "Данные предоставлены IQAir API • Обновление каждые 60 сек.",
        status: "Статус"
    }
};

const map = L.map('map', { zoomControl: false }).setView(ASTANA_COORDS, 12);

const darkTiles = L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; OpenStreetMap & CARTO',
    subdomains: 'abcd',
    maxZoom: 20
});
const lightTiles = L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; OpenStreetMap & CARTO',
    subdomains: 'abcd',
    maxZoom: 20
});
function updateMapTiles() {
    if (currentTheme === 'light') {
        if (map.hasLayer(darkTiles)) map.removeLayer(darkTiles);
        if (!map.hasLayer(lightTiles)) lightTiles.addTo(map);
    } else {
        if (map.hasLayer(lightTiles)) map.removeLayer(lightTiles);
        if (!map.hasLayer(darkTiles)) darkTiles.addTo(map);
    }
}
updateMapTiles();

let marker;
let regionMarkers = [];
let kazLayer = null;
let selectedCircle = null;

function getAQIInfo(aqi) {
    const t = TRANSLATIONS[currentLang];
    if (aqi <= 50) return { label: t.good, color: "#00e400", class: "good" };
    if (aqi <= 100) return { label: t.moderate, color: "#ffff00", class: "moderate" };
    if (aqi <= 150) return { label: t.sensitive, color: "#ff7e00", class: "sensitive" };
    if (aqi <= 200) return { label: t.unhealthy, color: "#ff0000", class: "unhealthy" };
    if (aqi <= 300) return { label: t.veryUnhealthy, color: "#8f3f97", class: "very-unhealthy" };
    return { label: t.hazardous, color: "#7e0023", class: "hazardous" };
}

function applyTheme() {
    document.documentElement.setAttribute('data-theme', currentTheme === 'light' ? 'light' : '');
    const icon = document.getElementById('theme-icon');
    if (icon) icon.textContent = currentTheme === 'light' ? '🌞' : '🌙';
    updateMapTiles();
    updateKazStyle();
}

function applyLanguage() {
    const t = TRANSLATIONS[currentLang];
    document.getElementById('lang-text').innerText = currentLang;
    
    // Update static texts
    document.getElementById('aqi-caption').innerText = t.aqiCaption;
    document.getElementById('side-title').innerText = t.regionsTitle;
    document.getElementById('region-search-input').placeholder = t.searchPlaceholder;
    document.getElementById('region-info-title').innerText = t.regionInfoTitle;
    document.getElementById('label-temp').innerText = t.temp;
    document.getElementById('label-hum').innerText = t.hum;
    document.getElementById('label-wind').innerText = t.wind;
    document.getElementById('dirty-title').innerText = t.dirtyTitle;
    document.getElementById('clean-title').innerText = t.cleanTitle;
    document.getElementById('footer-text').innerText = t.footer;
    
    // Refresh dynamic parts
    updateAirQuality();
    loadRegions(); 
    updateSummary();
}

function initToggles() {
    applyTheme();
    document.getElementById('lang-text').innerText = currentLang;

    const themeBtn = document.getElementById('theme-toggle');
    const langBtn = document.getElementById('lang-toggle');
    const menuBtn = document.getElementById('menu-toggle');
    const panel = document.getElementById('side-panel');
    const overlay = document.getElementById('side-overlay');
    const closeBtn = document.getElementById('side-close');

    if (themeBtn) {
        themeBtn.onclick = () => {
            currentTheme = currentTheme === 'light' ? 'dark' : 'light';
            localStorage.setItem('theme', currentTheme);
            applyTheme();
        };
    }
    
    if (langBtn) {
        langBtn.onclick = () => {
            currentLang = currentLang === 'kk' ? 'ru' : 'kk';
            localStorage.setItem('lang', currentLang);
            applyLanguage();
        };
    }

    if (menuBtn && panel && overlay && closeBtn) {
        const open = () => { panel.classList.add('open'); overlay.classList.add('open'); };
        const close = () => { panel.classList.remove('open'); overlay.classList.remove('open'); };
        menuBtn.onclick = open;
        overlay.onclick = close;
        closeBtn.onclick = close;
    }
}

function getKazStyle() {
    const color = currentTheme === 'light' ? '#0969da' : '#58a6ff';
    return { color, weight: 2, fill: false, opacity: 0.9 };
}

function updateKazStyle() {
    if (kazLayer) kazLayer.setStyle(getKazStyle());
}

async function loadKazakhstanBorder() {
    try {
        const url = 'https://raw.githubusercontent.com/johan/world.geo.json/master/countries/KAZ.geo.json';
        const res = await fetch(url);
        const geo = await res.json();
        kazLayer = L.geoJSON(geo, { style: getKazStyle() }).addTo(map);
        map.fitBounds(kazLayer.getBounds(), { padding: [20, 20] });
    } catch (e) {
        const rect = L.polygon([
            [55.5, 46.0], [55.5, 87.3], [40.0, 87.3], [40.0, 46.0]
        ], getKazStyle()).addTo(map);
        kazLayer = rect;
    }
}

async function updateAirQuality() {
    const t = TRANSLATIONS[currentLang];
    try {
        const url = selectedRegion ? `/api/air-quality?region=${encodeURIComponent(selectedRegion)}` : '/api/air-quality';
        const response = await fetch(url);
        if (!response.ok) throw new Error('Ошибка сети');
        
        const data = await response.json();
        const aqi = data.current.pollution.aqius;
        const weather = data.current.weather;
        const hasAQI = typeof aqi === 'number' && !Number.isNaN(aqi);
        const info = hasAQI ? getAQIInfo(aqi) : { label: t.noData, color: "#8b949e" };

        document.getElementById('aqi-value').innerText = hasAQI ? aqi : '--';
        document.getElementById('aqi-value').style.color = info.color;
        
        const statusEl = document.getElementById('aqi-status');
        statusEl.innerText = info.label;
        statusEl.style.backgroundColor = info.color + "22";
        statusEl.style.color = info.color;

        document.getElementById('temp-value').innerText = `${weather.tp}°C`;
        document.getElementById('humidity-value').innerText = `${weather.hu}%`;
        document.getElementById('wind-value').innerText = `${weather.ws} ${t.ms}`;
        
        document.getElementById('last-update').innerText = `${t.updateTime}: ${new Date().toLocaleTimeString()}`;
        
        let rn = data.city;
        if (data.region) {
            rn = (currentLang === 'kk' && data.region.name_kk) ? data.region.name_kk : data.region.name;
        }
        document.getElementById('region-name').innerText = rn;

        const location = (data.region && data.region.coords) ? data.region.coords : [data.location.coordinates[1], data.location.coordinates[0]];
        
        if (marker) {
            map.removeLayer(marker);
        }

        const icon = L.divIcon({
            className: 'custom-div-icon',
            html: `<div class="aqi-marker" style="background-color: ${info.color}">${hasAQI ? aqi : '--'}</div>`,
            iconSize: [40, 40],
            iconAnchor: [20, 20]
        });

        marker = L.marker(location, { icon: icon }).addTo(map);
        marker.bindPopup(`<b>${rn}</b><br>AQI: ${aqi}<br>${t.status}: ${info.label}`).openPopup();
        
        if (selectedCircle) map.removeLayer(selectedCircle);
        selectedCircle = L.circle(location, {
            radius: 50000,
            color: '#2ea043',
            weight: 2,
            fill: false
        }).addTo(map);

        const infoBox = document.getElementById('region-info-body');
        if (infoBox) {
            infoBox.innerHTML = `
                <div><b>${rn}</b></div>
                <div>AQI: ${hasAQI ? aqi : '—'} (${info.label})</div>
                <div>${t.temp}: ${weather.tp} °C</div>
                <div>${t.hum}: ${weather.hu} %</div>
                <div>${t.wind}: ${weather.ws} ${t.ms}</div>
            `;
        }

    } catch (error) {
        console.error('Fetch error:', error);
        document.getElementById('aqi-status').innerText = t.error;
    }
}

async function loadRegions() {
    const t = TRANSLATIONS[currentLang];
    const res = await fetch('/api/regions');
    const list = await res.json();
    const container = document.getElementById('side-list') || document.getElementById('regions-list');
    const searchEl = document.getElementById('region-search-input');
    if (!container) return;
    
    container.innerHTML = '';
    const byName = {};
    let aqiMap = {};
    try {
        const s = await fetch('/api/summary');
        const sd = await s.json();
        for (const it of [...sd.clean, ...sd.dirty]) {
            aqiMap[it.key] = it.aqi;
        }
    } catch (e) {}

    const urlParams = new URLSearchParams(location.search);
    const fromUrl = urlParams.get('region');
    const fromStorage = localStorage.getItem('region');
    selectedRegion = fromUrl || fromStorage || (list[0]?.key || null);

    for (const r of list) {
        const displayName = (currentLang === 'kk' && r.name_kk) ? r.name_kk : r.name;
        const btn = document.createElement('button');
        btn.className = 'region-btn' + (selectedRegion === r.key ? ' active' : '');
        btn.dataset.key = r.key;
        btn.dataset.name = displayName.toLowerCase();
        
        const badgeVal = (aqiMap[r.key] ?? '—');
        btn.innerHTML = `${displayName} <span class="badge">${badgeVal}</span>`;
        
        const badgeNum = typeof badgeVal === 'number' ? badgeVal : null;
        if (badgeNum !== null) {
            const infoColor = getAQIInfo(badgeNum).color;
            const b = btn.querySelector('.badge');
            if (b) {
                b.style.background = infoColor;
                b.style.color = '#000';
            }
        }
        btn.onclick = () => {
            selectedRegion = r.key;
            localStorage.setItem('region', selectedRegion);
            const params = new URLSearchParams(location.search);
            params.set('region', selectedRegion);
            history.replaceState({}, '', `${location.pathname}?${params.toString()}`);
            for (const c of container.querySelectorAll('.region-btn')) c.classList.remove('active');
            btn.classList.add('active');
            map.setView(r.coords, 11);
            updateAirQuality();
        };
        container.appendChild(btn);
        byName[displayName.toLowerCase()] = { r, btn };
    }
    addRegionMarkers(list);
    
    if (searchEl) {
        searchEl.oninput = () => {
            const q = searchEl.value.trim().toLowerCase();
            for (const btn of container.querySelectorAll('.region-btn')) {
                const txt = btn.dataset.name;
                btn.style.display = txt.includes(q) ? '' : 'none';
            }
        };
    }
}

function addRegionMarkers(list) {
    for (const m of regionMarkers) map.removeLayer(m);
    regionMarkers = [];
    for (const r of list) {
        const displayName = (currentLang === 'kk' && r.name_kk) ? r.name_kk : r.name;
        const m = L.circleMarker([r.coords[0], r.coords[1]], {
            radius: 6,
            color: '#fff',
            weight: 1,
            fillColor: '#2ea043',
            fillOpacity: 0.8
        }).addTo(map);
        m.bindTooltip(displayName, { permanent: false });
        m.on('click', () => {
            selectedRegion = r.key;
            localStorage.setItem('region', selectedRegion);
            const params = new URLSearchParams(location.search);
            params.set('region', selectedRegion);
            history.replaceState({}, '', `${location.pathname}?${params.toString()}`);
            map.setView(r.coords, 11);
            updateAirQuality();
        });
        regionMarkers.push(m);
    }
}

// Контрол выбора регионов на карте удалён — выбор только в шапке

async function updateSummary() {
    const res = await fetch('/api/summary');
    const data = await res.json();
    const dirtyEl = document.getElementById('dirty-list');
    const cleanEl = document.getElementById('clean-list');
    
    const render = (arr, el) => {
        el.innerHTML = '';
        for (const item of arr) {
            const info = getAQIInfo(item.aqi);
            const row = document.createElement('div');
            row.className = 'rank-item';
            
            const name = document.createElement('div');
            name.className = 'rank-name';
            
            let regionName = (currentLang === 'kk' && item.name_kk) ? item.name_kk : item.region;
            name.innerText = regionName;

            const badge = document.createElement('div');
            badge.className = 'rank-badge';
            badge.style.background = info.color;
            badge.innerText = item.aqi;
            row.appendChild(name);
            row.appendChild(badge);
            el.appendChild(row);
        }
    };
    render(data.dirty, dirtyEl);
    render(data.clean, cleanEl);
}

initToggles();
loadKazakhstanBorder();
loadRegions().then(() => {
    updateAirQuality();
    updateSummary();
    applyLanguage(); // Применяем язык после загрузки данных
});

setTimeout(() => {
    updateAirQuality();
    updateSummary();
    // Затем запускаем регулярное обновление каждую МИНУТУ (60 секунд)
    setInterval(() => {
        updateAirQuality();
        updateSummary();
    }, 60000);
}, 10000);
