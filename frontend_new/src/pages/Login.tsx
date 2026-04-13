import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  TextField,
  Card,
  CardContent,
  IconButton,
  Container,
  Alert,
} from '@mui/material';
import LanguageIcon from '@mui/icons-material/Language';
import { useAuth } from '@/context/AuthContext';
import { TRANSLATIONS } from '@/lib/utils';
import type { Language } from '@/types';

export function Login() {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [lang, setLang] = useState<Language>(localStorage.getItem('lang') as Language || 'ru');
  
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });
  
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});
  
  const t = TRANSLATIONS[lang];

  const validate = () => {
    const errors: Record<string, string> = {};
    if (!formData.email.includes('@')) {
      errors.email = lang === 'ru' ? 'Некорректный email' : 'Жарамсыз email';
    }
    if (formData.password.length < 6) {
      errors.password = lang === 'ru' ? 'Пароль должен быть не менее 6 символов' : 'Құпия сөз кем дегенде 6 таңба болуы керек';
    }
    setFormErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    
    setIsLoading(true);
    setError('');
    try {
      await login(formData);
      navigate('/');
    } catch (err) {
      setError(lang === 'ru' ? 'Неверный email или пароль' : 'Email немесе құпия сөз қате');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'background.default', py: 4 }}>
      <Container maxWidth="sm">
        <Card>
          <CardContent sx={{ p: 4 }}>
            {/* Logo */}
            <Box sx={{ textAlign: 'center', mb: 3 }}>
              <Box sx={{
                width: 12,
                height: 12,
                backgroundColor: '#3fb950',
                borderRadius: '50%',
                position: 'relative',
                mx: 'auto',
                mb: 2,
                '&::after': {
                  content: '""',
                  position: 'absolute',
                  width: '100%',
                  height: '100%',
                  backgroundColor: '#3fb950',
                  borderRadius: '50%',
                  animation: 'pulse 2s infinite',
                },
                '@keyframes pulse': {
                  '0%': { transform: 'scale(1)', opacity: 0.8 },
                  '100%': { transform: 'scale(3)', opacity: 0 },
                },
              }} />
              <Typography
                variant="h4"
                sx={{
                  fontWeight: 700,
                  background: 'linear-gradient(90deg, #58a6ff, #bc85ff)',
                  WebkitBackgroundClip: 'text',
                  WebkitTextFillColor: 'transparent',
                  backgroundClip: 'text',
                }}
              >
                QazaqAir
              </Typography>
            </Box>

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
              <Typography variant="h5" sx={{ fontWeight: 600 }} color="text.primary">
                {t.login}
              </Typography>
              <IconButton
                onClick={() => {
                  const newLang = lang === 'ru' ? 'kk' : 'ru';
                  setLang(newLang);
                  localStorage.setItem('lang', newLang);
                }}
                size="small"
              >
                <LanguageIcon />
                <Typography variant="caption" sx={{ ml: 0.5 }}>
                  {lang === 'ru' ? 'KK' : 'RU'}
                </Typography>
              </IconButton>
            </Box>

            <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
              {lang === 'ru' ? 'Введите данные для входа' : 'Кіру деректерін енгізіңіз'}
            </Typography>

            <Box component="form" onSubmit={onSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
              <TextField
                fullWidth
                label="Email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                error={!!formErrors.email}
                helperText={formErrors.email}
              />

              <TextField
                fullWidth
                label={t.password}
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                error={!!formErrors.password}
                helperText={formErrors.password}
              />

              {error && (
                <Alert severity="error" sx={{ borderRadius: '12px' }}>
                  {error}
                </Alert>
              )}

              <Button
                type="submit"
                fullWidth
                variant="contained"
                disabled={isLoading}
                sx={{
                  mt: 2,
                  py: 1.5,
                  borderRadius: '12px',
                  background: 'linear-gradient(90deg, #58a6ff, #bc85ff)',
                  '&:hover': {
                    background: 'linear-gradient(90deg, #388bfd, #a668ff)',
                  },
                }}
              >
                {isLoading ? t.loading : t.login}
              </Button>

              <Typography variant="body2" color="text.secondary" align="center" sx={{ mt: 2 }}>
                {t.noAccount}{' '}
                <Link to="/register" style={{ color: 'inherit' }}>
                  {t.register}
                </Link>
              </Typography>
            </Box>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
}
