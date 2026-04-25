import axios from 'axios';
import type { 
  AirQualityData, 
  SummaryData, 
  Region, 
  User, 
  LoginCredentials, 
  RegisterCredentials, 
  UpdateProfileData,
  AssistantResponse,
} from '@/types';

const API_BASE_URL = import.meta.env.VITE_API_URL || '';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to requests
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle auth errors
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Air Quality API
export const airQualityApi = {
  getCurrent: async (region?: string): Promise<AirQualityData> => {
    const params = region ? `?region=${encodeURIComponent(region)}` : '';
    const response = await apiClient.get(`/api/air-quality${params}`);
    return response.data;
  },

  getRegions: async (): Promise<Region[]> => {
    const response = await apiClient.get('/api/regions');
    return response.data;
  },

  getSummary: async (): Promise<SummaryData> => {
    const response = await apiClient.get('/api/summary');
    return response.data;
  },
};

// Auth API
export const authApi = {
  login: async (credentials: LoginCredentials): Promise<{ access_token: string; token_type: string; user: User }> => {
    const formData = new URLSearchParams();
    formData.append('username', credentials.email);
    formData.append('password', credentials.password);
    
    const response = await apiClient.post('/api/auth/login', formData, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });
    return response.data;
  },

  register: async (credentials: RegisterCredentials): Promise<{ message: string; user: User }> => {
    const response = await apiClient.post('/api/auth/register', credentials);
    return response.data;
  },

  getProfile: async (): Promise<User> => {
    const response = await apiClient.get('/api/auth/me');
    return response.data;
  },

  updateProfile: async (data: UpdateProfileData): Promise<User> => {
    const response = await apiClient.patch('/api/auth/me', data);
    return response.data;
  },
};

export const assistantApi = {
  ask: async (question: string, region?: string): Promise<AssistantResponse> => {
    const response = await apiClient.post('/api/assistant', { question, region });
    return response.data;
  },
};

export default apiClient;
