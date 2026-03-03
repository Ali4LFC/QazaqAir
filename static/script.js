const ASTANA_COORDS = [51.1694, 71.4491];
let selectedRegion = null;
let currentTheme = localStorage.getItem('theme') || 'dark';

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
    if (aqi <= 50) return { label: "Хорошо", color: "#00e400", class: "good" };
    if (aqi <= 100) return { label: "Умеренно", color: "#ffff00", class: "moderate" };
    if (aqi <= 150) return { label: "Нездорово для чувствительных", color: "#ff7e00", class: "sensitive" };
    if (aqi <= 200) return { label: "Нездорово", color: "#ff0000", class: "unhealthy" };
    if (aqi <= 300) return { label: "Очень нездорово", color: "#8f3f97", class: "very-unhealthy" };
    return { label: "Опасно", color: "#7e0023", class: "hazardous" };
}

function applyTheme() {
    document.documentElement.setAttribute('data-theme', currentTheme === 'light' ? 'light' : '');
    const icon = document.getElementById('theme-icon');
    if (icon) icon.textContent = currentTheme === 'light' ? '🌞' : '🌙';
    updateMapTiles();
    updateKazStyle();
}

function initThemeToggle() {
    applyTheme();
    const btn = document.getElementById('theme-toggle');
    const menu = document.getElementById('menu-toggle');
    const panel = document.getElementById('side-panel');
    const overlay = document.getElementById('side-overlay');
    const closeBtn = document.getElementById('side-close');
    if (btn) {
        btn.onclick = () => {
            currentTheme = currentTheme === 'light' ? 'dark' : 'light';
            localStorage.setItem('theme', currentTheme);
            applyTheme();
        };
    }
    if (menu && panel && overlay && closeBtn) {
        const open = () => { panel.classList.add('open'); overlay.classList.add('open'); };
        const close = () => { panel.classList.remove('open'); overlay.classList.remove('open'); };
        menu.onclick = open;
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
    try {
        const url = selectedRegion ? `/api/air-quality?region=${encodeURIComponent(selectedRegion)}` : '/api/air-quality';
        const response = await fetch(url);
        if (!response.ok) throw new Error('Ошибка сети');
        
        const data = await response.json();
        const aqi = data.current.pollution.aqius;
        const weather = data.current.weather;
        const hasAQI = typeof aqi === 'number' && !Number.isNaN(aqi);
        const info = hasAQI ? getAQIInfo(aqi) : { label: "Нет данных", color: "#8b949e" };

        document.getElementById('aqi-value').innerText = hasAQI ? aqi : '--';
        document.getElementById('aqi-value').style.color = info.color;
        
        const statusEl = document.getElementById('aqi-status');
        statusEl.innerText = info.label;
        statusEl.style.backgroundColor = info.color + "22";
        statusEl.style.color = info.color;

        document.getElementById('temp-value').innerText = `${weather.tp}°C`;
        document.getElementById('humidity-value').innerText = `${weather.hu}%`;
        document.getElementById('wind-value').innerText = `${weather.ws} м/с`;
        
        document.getElementById('last-update').innerText = `Обновлено: ${new Date().toLocaleTimeString()}`;
        const rn = data.region ? data.region.name : data.city;
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
        marker.bindPopup(`<b>${data.city}</b><br>AQI: ${aqi}<br>Статус: ${info.label}`).openPopup();
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
                <div>Температура: ${weather.tp} °C</div>
                <div>Влажность: ${weather.hu} %</div>
                <div>Ветер: ${weather.ws} м/с</div>
            `;
        }

    } catch (error) {
        console.error('Fetch error:', error);
        document.getElementById('aqi-status').innerText = 'Ошибка загрузки';
    }
}

async function loadRegions() {
    const res = await fetch('/api/regions');
    const list = await res.json();
    const container = document.getElementById('side-list') || document.getElementById('regions-list');
    container.innerHTML = '';
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
        const btn = document.createElement('button');
        btn.className = 'region-btn' + (selectedRegion === r.key ? ' active' : '');
        const badgeVal = (aqiMap[r.key] ?? '—');
        btn.innerHTML = `${r.name} <span class="badge">${badgeVal}</span>`;
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
    }
    addRegionMarkers(list);
}

function addRegionMarkers(list) {
    for (const m of regionMarkers) map.removeLayer(m);
    regionMarkers = [];
    for (const r of list) {
        const m = L.circleMarker([r.coords[0], r.coords[1]], {
            radius: 6,
            color: '#fff',
            weight: 1,
            fillColor: '#2ea043',
            fillOpacity: 0.8
        }).addTo(map);
        m.bindTooltip(r.name, { permanent: false });
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
            name.innerText = item.region;
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

initThemeToggle();
loadKazakhstanBorder();
loadRegions().then(() => {
    updateAirQuality();
    updateSummary();
});

setInterval(() => {
    updateAirQuality();
    updateSummary();
}, 10000);
