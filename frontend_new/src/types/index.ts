export interface Region {
  key: string;
  name: string;
  name_kk: string;
  city: string;
  coords: [number, number];
}

export interface AirQualityData {
  city: string;
  region?: Region;
  location: {
    type: string;
    coordinates: [number, number];
  };
  current: {
    pollution: {
      ts: string;
      aqius: number;
      mainus: string;
      aqicn: number;
      maincn: string;
    };
    weather: {
      ts: string;
      tp: number;
      pr: number;
      hu: number;
      ws: number;
      wd: number;
      ic: string;
    };
  };
}

export interface SummaryItem {
  key: string;
  region: string;
  name_kk?: string;
  city: string;
  aqi: number;
  ts: string;
}

export interface SummaryData {
  clean: SummaryItem[];
  dirty: SummaryItem[];
  updated_at: string;
}

export interface User {
  id: number;
  email: string;
  name: string;
  city_key: string | null;
  created_at: string;
}

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegisterCredentials {
  email: string;
  password: string;
  name: string;
}

export interface UpdateProfileData {
  name?: string;
  city_key?: string;
}

export interface ApiError {
  detail: string;
}

export type Language = 'kk' | 'ru';
export type Theme = 'light' | 'dark';
