import { createContext, useContext, useState, useEffect, type ReactNode } from 'react';
import { authApi } from '@/api/client';
import type { User, LoginCredentials, RegisterCredentials, UpdateProfileData } from '@/types';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (credentials: LoginCredentials) => Promise<void>;
  register: (credentials: RegisterCredentials) => Promise<void>;
  logout: () => void;
  updateUser: (data: UpdateProfileData) => Promise<void>;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      refreshUser().finally(() => setIsLoading(false));
    } else {
      setIsLoading(false);
    }
  }, []);

  const login = async (credentials: LoginCredentials) => {
    const response = await authApi.login(credentials);
    localStorage.setItem('token', response.access_token);
    setUser(response.user);
  };

  const register = async (credentials: RegisterCredentials) => {
    await authApi.register(credentials);
    // Auto login after registration
    await login({ email: credentials.email, password: credentials.password });
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  const updateUser = async (data: UpdateProfileData) => {
    const updatedUser = await authApi.updateProfile(data);
    setUser(updatedUser);
  };

  const refreshUser = async () => {
    try {
      const userData = await authApi.getProfile();
      setUser(userData);
    } catch {
      localStorage.removeItem('token');
      setUser(null);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        isLoading,
        login,
        register,
        logout,
        updateUser,
        refreshUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
