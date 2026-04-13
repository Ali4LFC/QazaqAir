import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import {
  Box,
  Typography,
  Button,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Card,
  CardContent,
  IconButton,
  Container,
  Alert,
} from '@mui/material';
import LanguageIcon from '@mui/icons-material/Language';
import { useAuth } from '@/context/AuthContext';
import { REGIONS, TRANSLATIONS } from '@/lib/utils';
import type { Language } from '@/types';

export function Register() {
  const navigate = useNavigate();
  const { register: registerUser } = useAuth();
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [lang, setLang] = useState<Language>(localStorage.getItem('lang') as Language || 'ru');
  
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    city_key: '',
  });
  
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});
  
  const t = TRANSLATIONS[lang];

  const cityOptions = [
    { value: '', label: lang === 'ru' ? 'Выберите город (необязательно)' : 'Қаланы таңдаңыз (міндетті емес)' },
    ...REGIONS.map(r => ({
      value: r.key,
      label: lang === 'kk' && r.name_kk ? r.name_kk : r.name
    }))
  ];

  const validate = () => {
    const errors: Record<string, string> = {};
    if (formData.name.length < 2) {
      errors.name = lang === 'ru' ? 'Имя должно быть не менее 2 символов' : 'Есім кем дегенде 2 таңба болуы керек';
    }
    if (!formData.email.includes('@')) {
      errors.email = lang === 'ru' ? 'Некорректный email' : 'Жарамсыз email';
    }
    if (formData.password.length < 6) {
      errors.password = lang === 'ru' ? 'Пароль должен быть не менее 6 символов' : 'Құпия сөз кем дегенде 6 таңба болуы керек';
    }
    if (formData.password !== formData.confirmPassword) {
      errors.confirmPassword = lang === 'ru' ? 'Пароли не совпадают' : 'Құпия сөздер сәйкес келмейді';
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
      await registerUser({
        email: formData.email,
        password: formData.password,
        name: formData.name,
      });
      navigate('/');
    } catch (err: any) {
      setError(err.response?.data?.detail || (lang === 'ru' ? 'Ошибка регистрации' : 'Тіркелу қатесі'));
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
                {t.register}
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
              {lang === 'ru' ? 'Создайте новый аккаунт' : 'Жаңа тіркелгі жасаңыз'}
            </Typography>

            <Box component="form" onSubmit={onSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
              <TextField
                fullWidth
                label={t.name}
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                error={!!formErrors.name}
                helperText={formErrors.name}
              />

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

              <TextField
                fullWidth
                label={t.confirmPassword}
                type="password"
                value={formData.confirmPassword}
                onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
                error={!!formErrors.confirmPassword}
                helperText={formErrors.confirmPassword}
              />

              <FormControl fullWidth>
                <InputLabel sx={{ color: '#8b949e' }}>
                  {lang === 'ru' ? 'Ваш город' : 'Сіздің қалаңыз'}
                </InputLabel>
                <Select
                  value={formData.city_key}
                  onChange={(e) => setFormData({ ...formData, city_key: e.target.value })}
                  sx={{
                    bgcolor: 'rgba(31, 35, 41, 0.8)',
                    borderRadius: '12px',
                  }}
                >
                  {cityOptions.map((option) => (
                    <MenuItem key={option.value} value={option.value}>
                      {option.label}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

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
                {isLoading ? t.loading : t.register}
              </Button>

              <Typography variant="body2" color="text.secondary" align="center" sx={{ mt: 2 }}>
                {t.haveAccount}{' '}
                <Link to="/login" style={{ color: 'inherit' }}>
                  {t.login}
                </Link>
              </Typography>
            </Box>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
}
