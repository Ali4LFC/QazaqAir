import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useAuth } from '@/context/AuthContext';
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
  Avatar,
  Divider,
} from '@mui/material';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import LanguageIcon from '@mui/icons-material/Language';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import LogoutIcon from '@mui/icons-material/Logout';
import PersonIcon from '@mui/icons-material/Person';
import { TRANSLATIONS, REGIONS } from '@/lib/utils';
import type { Language } from '@/types';

const profileSchema = z.object({
  name: z.string().min(2, 'Имя должно быть не менее 2 символов'),
  city_key: z.string().optional(),
});

type ProfileFormData = z.infer<typeof profileSchema>;

export function Profile() {
  const navigate = useNavigate();
  const { user, logout, updateUser, isLoading: authLoading } = useAuth();
  const [isLoading, setIsLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [lang, setLang] = useState<Language>(localStorage.getItem('lang') as Language || 'ru');

  const t = TRANSLATIONS[lang];

  const cityOptions = [
    { value: '', label: lang === 'ru' ? 'Не выбран' : 'Таңдалмаған' },
    ...REGIONS.map(r => ({
      value: r.key,
      label: lang === 'kk' && r.name_kk ? r.name_kk : r.name
    }))
  ];

  const userCity = user?.city_key ? REGIONS.find(r => r.key === user.city_key) : null;

  const {
    register,
    handleSubmit,
    formState: { errors },
    setValue,
    watch,
  } = useForm<ProfileFormData>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: user?.name || '',
      city_key: user?.city_key || '',
    },
  });

  const selectedCity = watch('city_key');

  const onSubmit = async (data: ProfileFormData) => {
    setIsLoading(true);
    setSuccess(false);
    try {
      await updateUser(data);
      setSuccess(true);
      setTimeout(() => setSuccess(false), 3000);
    } catch (err) {
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  const toggleLang = () => {
    const newLang = lang === 'ru' ? 'kk' : 'ru';
    setLang(newLang);
    localStorage.setItem('lang', newLang);
  };

  if (authLoading) {
    return (
      <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: 'background.default' }}>
        <Typography>{t.loading}</Typography>
      </Box>
    );
  }

  if (!user) {
    return (
      <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', p: 2, bgcolor: 'background.default' }}>
        <Card sx={{ width: '100%', maxWidth: 400 }}>
          <CardContent sx={{ p: 3 }}>
            <Typography variant="h6" sx={{ fontWeight: 600 }} gutterBottom>{t.notLoggedIn}</Typography>
            <Button component={Link} to="/login" fullWidth variant="contained">
              {t.login}
            </Button>
          </CardContent>
        </Card>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: 'background.default', py: 4 }}>
      <Container maxWidth="sm">
        {/* Header */}
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Button
            startIcon={<ArrowBackIcon />}
            onClick={() => navigate('/')}
            variant="outlined"
            size="small"
          >
            {lang === 'ru' ? 'На главную' : 'Басты бетке'}
          </Button>
          <IconButton onClick={toggleLang} size="small">
            <LanguageIcon sx={{ fontSize: 18, mr: 0.5 }} />
            <Typography variant="caption">{lang === 'ru' ? 'KK' : 'RU'}</Typography>
          </IconButton>
        </Box>

        {/* Profile Card */}
        <Card>
          <CardContent sx={{ p: 4 }}>
            {/* Avatar & Name */}
            <Box sx={{ textAlign: 'center', mb: 4 }}>
              <Avatar
                sx={{
                  width: 80,
                  height: 80,
                  mx: 'auto',
                  mb: 2,
                  bgcolor: 'primary.main',
                  fontSize: '2rem',
                }}
              >
                <PersonIcon fontSize="large" />
              </Avatar>
              <Typography variant="h5" sx={{ fontWeight: 700 }}>
                {user.name}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                {user.email}
              </Typography>
            </Box>

            {/* Current City Info */}
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                gap: 2,
                p: 2,
                mb: 3,
                bgcolor: 'rgba(88, 166, 255, 0.1)',
                borderRadius: '12px',
                border: '1px solid rgba(88, 166, 255, 0.2)',
              }}
            >
              <LocationOnIcon color="primary" />
              <Box>
                <Typography variant="body2" color="text.secondary">{t.myCity}</Typography>
                <Typography sx={{ fontWeight: 600 }}>
                  {userCity
                    ? (lang === 'kk' && userCity.name_kk ? userCity.name_kk : userCity.name)
                    : (lang === 'ru' ? 'Не выбран' : 'Таңдалмаған')
                  }
                </Typography>
              </Box>
            </Box>

            <Divider sx={{ my: 3 }} />

            {/* Edit Form */}
            <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
              {lang === 'ru' ? 'Редактировать профиль' : 'Профильді өңдеу'}
            </Typography>

            <Box component="form" onSubmit={handleSubmit(onSubmit)} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
              <TextField
                fullWidth
                label={t.name}
                {...register('name')}
                error={!!errors.name}
                helperText={errors.name?.message}
              />

              <FormControl fullWidth>
                <InputLabel>{t.selectCity}</InputLabel>
                <Select
                  value={selectedCity || ''}
                  label={t.selectCity}
                  onChange={(e) => setValue('city_key', e.target.value)}
                >
                  {cityOptions.map((option) => (
                    <MenuItem key={option.value} value={option.value}>
                      {option.label}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>

              {success && (
                <Alert severity="success" sx={{ borderRadius: '12px' }}>
                  {lang === 'ru' ? 'Изменения сохранены!' : 'Өзгерістер сақталды!'}
                </Alert>
              )}

              <Button
                type="submit"
                variant="contained"
                fullWidth
                disabled={isLoading}
                sx={{
                  mt: 1,
                  py: 1.5,
                  borderRadius: '12px',
                  background: 'linear-gradient(90deg, #58a6ff, #bc85ff)',
                  '&:hover': {
                    background: 'linear-gradient(90deg, #388bfd, #a668ff)',
                  },
                }}
              >
                {isLoading ? t.loading : t.save}
              </Button>
            </Box>

            <Divider sx={{ my: 3 }} />

            {/* Logout */}
            <Button
              variant="outlined"
              color="error"
              fullWidth
              onClick={handleLogout}
              startIcon={<LogoutIcon />}
              sx={{
                py: 1.5,
                borderRadius: '12px',
                borderColor: 'rgba(255, 0, 0, 0.3)',
                '&:hover': {
                  borderColor: 'error.main',
                  bgcolor: 'rgba(255, 0, 0, 0.1)',
                },
              }}
            >
              {t.logout}
            </Button>
          </CardContent>
        </Card>
      </Container>
    </Box>
  );
}
