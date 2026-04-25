import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function getAQIInfo(aqi: number) {
  if (aqi <= 50) return { label: "good", color: "#00e400", class: "good", text: "Жақсы / Хорошо" };
  if (aqi <= 100) return { label: "moderate", color: "#ffff00", class: "moderate", text: "Орташа / Умеренно" };
  if (aqi <= 150) return { label: "sensitive", color: "#ff7e00", class: "sensitive", text: "Сезімтал топтар үшін зиянды / Нездорово для чувствительных" };
  if (aqi <= 200) return { label: "unhealthy", color: "#ff0000", class: "unhealthy", text: "Зиянды / Нездорово" };
  if (aqi <= 300) return { label: "very-unhealthy", color: "#8f3f97", class: "very-unhealthy", text: "Өте зиянды / Очень нездорово" };
  return { label: "hazardous", color: "#7e0023", class: "hazardous", text: "Қауіпті / Опасно" };
}

export function getAQIColor(aqi: number | null): string {
  if (aqi === null) return '#8b949e';
  if (aqi <= 50) return '#00e400';
  if (aqi <= 100) return '#ffff00';
  if (aqi <= 150) return '#ff7e00';
  if (aqi <= 200) return '#ff0000';
  if (aqi <= 300) return '#8f3f97';
  return '#7e0023';
}

export function getAQILabel(aqi: number | null, lang: 'kk' | 'ru' = 'ru'): string {
  if (aqi === null) return lang === 'ru' ? 'Нет данных' : 'Мәлімет жоқ';
  return getAQIText(aqi, lang);
}

export function getAQIText(aqi: number, lang: 'kk' | 'ru') {
  const t = {
    kk: {
      good: "Жақсы",
      moderate: "Орташа",
      sensitive: "Сезімтал топтар үшін зиянды",
      unhealthy: "Зиянды",
      veryUnhealthy: "Өте зиянды",
      hazardous: "Қауіпті",
    },
    ru: {
      good: "Хорошо",
      moderate: "Умеренно",
      sensitive: "Нездорово для чувствительных",
      unhealthy: "Нездорово",
      veryUnhealthy: "Очень нездорово",
      hazardous: "Опасно",
    }
  };
  
  if (aqi <= 50) return t[lang].good;
  if (aqi <= 100) return t[lang].moderate;
  if (aqi <= 150) return t[lang].sensitive;
  if (aqi <= 200) return t[lang].unhealthy;
  if (aqi <= 300) return t[lang].veryUnhealthy;
  return t[lang].hazardous;
}

export const REGIONS = [
  { key: "astana", name: "Астана", name_kk: "Астана", city: "Astana", coords: [51.1694, 71.4491] as [number, number] },
  { key: "almaty_city", name: "Алматы", name_kk: "Алматы", city: "Almaty", coords: [43.2383, 76.9453] as [number, number] },
  { key: "shymkent", name: "Шымкент", name_kk: "Шымкент", city: "Shymkent", coords: [42.3417, 69.5901] as [number, number] },
  { key: "akmola", name: "Акмолинская область", name_kk: "Ақмола облысы", city: "Kokshetau", coords: [53.2833, 69.3833] as [number, number] },
  { key: "aktobe", name: "Актюбинская область", name_kk: "Ақтөбе облысы", city: "Aktobe", coords: [50.2833, 57.1667] as [number, number] },
  { key: "almaty_obl", name: "Алматинская область", name_kk: "Алматы облысы", city: "Taldykorgan", coords: [45.0167, 78.3667] as [number, number] },
  { key: "atyrau", name: "Атырауская область", name_kk: "Атырау облысы", city: "Atyrau", coords: [47.1167, 51.8833] as [number, number] },
  { key: "east_kz", name: "Восточно-Казахстанская область", name_kk: "Шығыс Қазақстан облысы", city: "Oskemen", coords: [49.9667, 82.6167] as [number, number] },
  { key: "zhambyl", name: "Жамбылская область", name_kk: "Жамбыл облысы", city: "Taraz", coords: [42.9000, 71.3667] as [number, number] },
  { key: "west_kz", name: "Западно-Казахстанская область", name_kk: "Батыс Қазақстан облысы", city: "Oral", coords: [51.2225, 51.3866] as [number, number] },
  { key: "karaganda", name: "Карагандинская область", name_kk: "Қарағанды облысы", city: "Karaganda", coords: [49.8047, 73.1094] as [number, number] },
  { key: "kostanay", name: "Костанайская область", name_kk: "Қостанай облысы", city: "Kostanay", coords: [53.2144, 63.6246] as [number, number] },
  { key: "kyzylorda", name: "Кызылординская область", name_kk: "Қызылорда облысы", city: "Kyzylorda", coords: [44.8500, 65.5000] as [number, number] },
  { key: "mangystau", name: "Мангистауская область", name_kk: "Маңғыстау облысы", city: "Aktau", coords: [43.6500, 51.1667] as [number, number] },
  { key: "north_kz", name: "Северо-Казахстанская область", name_kk: "Солтүстік Қазақстан облысы", city: "Petropavl", coords: [54.8667, 69.1500] as [number, number] },
  { key: "pavlodar", name: "Павлодарская область", name_kk: "Павлодар облысы", city: "Pavlodar", coords: [52.3000, 76.9500] as [number, number] },
  { key: "turkistan", name: "Туркестанская область", name_kk: "Түркістан облысы", city: "Turkistan", coords: [43.3000, 68.2667] as [number, number] },
  { key: "abay", name: "Абайская область", name_kk: "Абай облысы", city: "Semey", coords: [50.4333, 80.2667] as [number, number] },
  { key: "ulytau", name: "Улытауская область", name_kk: "Ұлытау облысы", city: "Zhezkazgan", coords: [47.7833, 67.7000] as [number, number] },
  { key: "jetisu", name: "Жетысуская область", name_kk: "Жетісу облысы", city: "Taldykorgan", coords: [45.0167, 78.3667] as [number, number] },
];

export const TRANSLATIONS = {
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
    aqiLegend: "Расшифровка AQI",
    login: "Кіру",
    register: "Тіркелу",
    logout: "Шығу",
    profile: "Жеке кабинет",
    email: "Электрондық пошта",
    password: "Құпия сөз",
    confirmPassword: "Құпия сөзді растаңыз",
    name: "Аты",
    selectCity: "Қалаңызды таңдаңыз",
    save: "Сақтау",
    cancel: "Болдырмау",
    welcome: "Қош келдіңіз",
    notLoggedIn: "Сіз жүйеге кірмегенсіз",
    myCity: "Менің қалам",
    changeCity: "Қаланы өзгерту",
    haveAccount: "Аккаунтыңыз бар ма?",
    noAccount: "Аккаунтыңыз жоқ па?",
    assistantButton: "Ауа райы көмекшісі",
    assistantTitle: "AI-көмекші",
    assistantGreeting: "Сәлем! Мен ауа райы мен ауа сапасы бойынша көмекшімін. Температура, ылғалдылық, жел немесе AQI туралы сұраңыз.",
    assistantThinking: "Көмекші ойлануда...",
    assistantPlaceholder: "Ауа райы мен AQI туралы сұраңыз...",
    assistantSend: "Жіберу",
    assistantError: "Көмекшіден жауап алу мүмкін болмады. Қайта көріңіз.",
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
    login: "Войти",
    register: "Регистрация",
    logout: "Выйти",
    profile: "Личный кабинет",
    email: "Email",
    password: "Пароль",
    confirmPassword: "Подтвердите пароль",
    name: "Имя",
    selectCity: "Выберите ваш город",
    save: "Сохранить",
    cancel: "Отмена",
    welcome: "Добро пожаловать",
    notLoggedIn: "Вы не вошли в систему",
    myCity: "Мой город",
    changeCity: "Сменить город",
    haveAccount: "Уже есть аккаунт?",
    noAccount: "Нет аккаунта?",
    assistantButton: "Помощник по погоде",
    assistantTitle: "AI-помощник",
    assistantGreeting: "Привет! Я помощник по погоде и качеству воздуха. Спроси про температуру, влажность, ветер или AQI в регионе.",
    assistantThinking: "Помощник думает...",
    assistantPlaceholder: "Спросите про погоду и AQI...",
    assistantSend: "Отпр.",
    assistantError: "Не удалось получить ответ помощника. Попробуйте еще раз.",
  }
};
