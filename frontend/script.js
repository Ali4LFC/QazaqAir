const ASTANA_COORDS = [51.1694, 71.4491];
let selectedRegion = null;
let secondRegion = null;
let isCompareMode = false;
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
        status: "Мәртебесі",
        compare: "Салыстыру",
        compareTitle: "Аймақтарды салыстыру",
        close: "Жабу",
        aqiLevels: "AQI деңгейлері",
        aqiLegend: "AQI деңгейлері",
        aqiGoodDesc: "Ауа сапасы қанағаттанарлық деп саналады, ал ауаның ластануы минималды қауіп төндіреді немесе мүлдем қауіп төндірмейді.",
        aqiModerateDesc: "Ауа сапасы қолайлы; дегенмен, кейбір ластаушы заттар үшін ауаның ластануына ерекше сезімтал адамдардың өте аз саны үшін денсаулыққа қатысты орташа қауіп болуы мүмкін.",
        aqiSensitiveDesc: "Сезімтал топтардың мүшелері денсаулыққа әсер етуі мүмкін. Жалпы жұртшылық зардап шегуі екіталай.",
        aqiUnhealthyDesc: "Әркім денсаулыққа әсерін тигізе бастауы мүмкін; сезімтал топтардың мүшелері денсаулыққа неғұрлым ауыр әсер етуі мүмкін.",
        aqiVeryUnhealthyDesc: "Төтенше жағдайлардағы денсаулық туралы ескертулер. Бүкіл халық зардап шегуі мүмкін.",
        aqiHazardousDesc: "Денсаулық туралы ескерту: әркім денсаулыққа неғұрлым ауыр әсер етуі мүмкін."
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
        status: "Статус",
        compare: "Сравнить",
        compareTitle: "Сравнение регионов",
        close: "Закрыть",
        aqiLevels: "Уровни AQI",
        aqiLegend: "Расшифровка AQI",
        aqiGoodDesc: "Качество воздуха считается удовлетворительным, а загрязнение воздуха представляет минимальный риск или не представляет его вовсе.",
        aqiModerateDesc: "Качество воздуха приемлемое; однако для некоторых загрязнителей может существовать умеренный риск для здоровья для очень небольшого числа людей, которые необычно чувствительны к загрязнению воздуха.",
        aqiSensitiveDesc: "Члены чувствительных групп могут испытывать последствия для здоровья. Широкая общественность вряд ли пострадает.",
        aqiUnhealthyDesc: "Каждый может начать испытывать последствия для здоровья; члены чувствительных групп могут испытывать более серьезные последствия для здоровья.",
        aqiVeryUnhealthyDesc: "Предупреждения о здоровье в чрезвычайных ситуациях. Скорее всего, пострадает все население.",
        aqiHazardousDesc: "Предупреждение о здоровье: каждый может испытывать более серьезные последствия для здоровья."
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

    document.getElementById('modal-title').innerText = t.aqiLevels;
    document.getElementById('modal-close').title = t.close;
    document.getElementById('aqi-good-label').innerText = t.good;
    document.getElementById('aqi-good-desc').innerText = t.aqiGoodDesc;
    document.getElementById('aqi-moderate-label').innerText = t.moderate;
    document.getElementById('aqi-moderate-desc').innerText = t.aqiModerateDesc;
    document.getElementById('aqi-sensitive-label').innerText = t.sensitive;
    document.getElementById('aqi-sensitive-desc').innerText = t.aqiSensitiveDesc;
    document.getElementById('aqi-unhealthy-label').innerText = t.unhealthy;
    document.getElementById('aqi-unhealthy-desc').innerText = t.aqiUnhealthyDesc;
    document.getElementById('aqi-very-unhealthy-label').innerText = t.veryUnhealthy;
    document.getElementById('aqi-very-unhealthy-desc').innerText = t.aqiVeryUnhealthyDesc;
    document.getElementById('aqi-hazardous-label').innerText = t.hazardous;
    document.getElementById('aqi-hazardous-desc').innerText = t.aqiHazardousDesc;

    document.getElementById('compare-btn').innerText = t.compare;
    document.getElementById('compare-modal-title').innerText = t.compareTitle;
    document.getElementById('compare-modal-close').title = t.close;
    document.getElementById('compare-label-temp').innerText = t.temp;
    document.getElementById('compare-label-hum').innerText = t.hum;
    document.getElementById('compare-label-wind').innerText = t.wind;
    document.getElementById('aqi-legend-btn').innerText = t.aqiLegend;

    document.getElementById('legend-title').innerText = t.aqiLevels;
    document.getElementById('leg-good').innerText = t.good;
    document.getElementById('leg-mod').innerText = t.moderate;
    document.getElementById('leg-sens').innerText = t.sensitive;
    document.getElementById('leg-unhealthy').innerText = t.unhealthy;
    document.getElementById('leg-very').innerText = t.veryUnhealthy;
    document.getElementById('leg-haz').innerText = t.hazardous;
    
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
        menuBtn.onclick = (e) => { e.stopPropagation(); open(); };
        overlay.onclick = close;
        closeBtn.onclick = close;

        // Close sidebar when clicking anywhere outside it
        document.addEventListener('click', (e) => {
            if (panel.classList.contains('open') && !panel.contains(e.target) && e.target !== menuBtn) {
                close();
            }
        });
    }

    // Modal logic
    const aqiModal = document.getElementById('aqi-modal');
    const compareModal = document.getElementById('compare-modal');
    const modalOverlay = document.getElementById('modal-overlay');
    const aqiInfoBtn = document.getElementById('aqi-info-btn');
    const aqiLegendBtn = document.getElementById('aqi-legend-btn');
    const modalClose = document.getElementById('modal-close');
    const compareBtn = document.getElementById('compare-btn');
    const compareModalClose = document.getElementById('compare-modal-close');

    const openModal = (modal) => {
        modal.classList.add('open');
        modalOverlay.classList.add('open');
    };

    const closeModals = () => {
        aqiModal.classList.remove('open');
        compareModal.classList.remove('open');
        modalOverlay.classList.remove('open');
    };

    if (aqiInfoBtn) aqiInfoBtn.onclick = () => openModal(aqiModal);
    if (aqiLegendBtn) aqiLegendBtn.onclick = () => openModal(aqiModal);
    if (modalClose) modalClose.onclick = closeModals;
    if (modalOverlay) modalOverlay.onclick = closeModals;
    if (compareModalClose) compareModalClose.onclick = closeModals;

    if (compareBtn) {
        compareBtn.onclick = (e) => {
            e.stopPropagation();
            isCompareMode = !isCompareMode;
            compareBtn.classList.toggle('active');
            if (isCompareMode) {
                // Open side panel to let user select second region
                panel.classList.add('open');
                overlay.classList.add('open');
            } else {
                secondRegion = null;
            }
        };
    }
}

function getRegionDisplayName(key, list) {
    const r = list.find(item => item.key === key);
    if (!r) return key;
    return (currentLang === 'kk' && r.name_kk) ? r.name_kk : r.name;
}

async function fetchRegionData(region) {
    const url = region ? `/api/air-quality?region=${encodeURIComponent(region)}` : '/api/air-quality';
    const response = await fetch(url);
    if (!response.ok) throw new Error('Ошибка сети');
    return await response.json();
}

let cachedRegions = null;

async function showComparison(region1, region2) {
    const t = TRANSLATIONS[currentLang];
    const compareModal = document.getElementById('compare-modal');
    const modalOverlay = document.getElementById('modal-overlay');
    const panel = document.getElementById('side-panel');
    const overlay = document.getElementById('side-overlay');
    const compareBtn = document.getElementById('compare-btn');
    
    // Show loading state
    const originalText = compareBtn.innerText;
    compareBtn.innerText = t.loading;
    compareBtn.disabled = true;

    try {
        if (!cachedRegions) {
            const res = await fetch('/api/regions');
            cachedRegions = await res.json();
        }

        const [data1, data2] = await Promise.all([
            fetchRegionData(region1),
            fetchRegionData(region2)
        ]);

        document.getElementById('compare-region-1-name').innerText = getRegionDisplayName(region1 || "astana", cachedRegions);
        document.getElementById('compare-region-2-name').innerText = getRegionDisplayName(region2, cachedRegions);

        const aqi1 = data1.current.pollution.aqius;
        const aqi2 = data2.current.pollution.aqius;
        const info1 = getAQIInfo(aqi1);
        const info2 = getAQIInfo(aqi2);

        const aqi1El = document.getElementById('compare-aqi-1');
        aqi1El.innerText = aqi1;
        aqi1El.style.color = info1.color;

        const aqi2El = document.getElementById('compare-aqi-2');
        aqi2El.innerText = aqi2;
        aqi2El.style.color = info2.color;

        document.getElementById('compare-temp-1').innerText = `${data1.current.weather.tp}°C`;
        document.getElementById('compare-temp-2').innerText = `${data2.current.weather.tp}°C`;
        document.getElementById('compare-hum-1').innerText = `${data1.current.weather.hu}%`;
        document.getElementById('compare-hum-2').innerText = `${data2.current.weather.hu}%`;
        document.getElementById('compare-wind-1').innerText = `${data1.current.weather.ws} ${t.ms}`;
        document.getElementById('compare-wind-2').innerText = `${data2.current.weather.ws} ${t.ms}`;

        compareModal.classList.add('open');
        modalOverlay.classList.add('open');
        if (panel) panel.classList.remove('open');
        if (overlay) overlay.classList.remove('open');
    } catch (e) {
        console.error(e);
        alert(t.error);
    } finally {
        isCompareMode = false;
        compareBtn.classList.remove('active');
        compareBtn.innerText = t.compare;
        compareBtn.disabled = false;
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
    const [res, s] = await Promise.all([
        fetch('/api/regions'),
        fetch('/api/summary')
    ]);
    const list = await res.json();
    const sd = await s.json();
    
    const container = document.getElementById('side-list') || document.getElementById('regions-list');
    const searchEl = document.getElementById('region-search-input');
    if (!container) return;
    
    container.innerHTML = '';
    const byName = {};
    let aqiMap = {};
    
    for (const it of [...sd.clean, ...sd.dirty]) {
        aqiMap[it.key] = it.aqi;
    }

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
            if (isCompareMode) {
                secondRegion = r.key;
                showComparison(selectedRegion, secondRegion);
                return;
            }
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
