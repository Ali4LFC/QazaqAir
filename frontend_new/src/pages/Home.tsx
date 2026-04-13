import { useEffect, useState, useCallback } from 'react';
import { MapContainer, TileLayer, Marker, Circle, useMap, GeoJSON } from 'react-leaflet';
import { Link } from 'react-router-dom';
import {
  Box,
  Typography,
  IconButton,
  Button,
  Card,
  CardContent,
  Dialog,
  DialogTitle,
  DialogContent,
  TextField,
  List,
  ListItem,
  ListItemButton,
  Chip,
  AppBar,
  Toolbar,
  Container,
  Grid,
  keyframes,
  useTheme,
} from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import PersonIcon from '@mui/icons-material/Person';
import DarkModeIcon from '@mui/icons-material/DarkMode';
import LightModeIcon from '@mui/icons-material/LightMode';
import InfoIcon from '@mui/icons-material/Info';
import CompareArrowsIcon from '@mui/icons-material/CompareArrows';
import CloseIcon from '@mui/icons-material/Close';
import { airQualityApi } from '@/api/client';
import { useAuth } from '@/context/AuthContext';
import { useThemeContext } from '@/main';
import { getAQIInfo, getAQIText, TRANSLATIONS, REGIONS } from '@/lib/utils';
import type { AirQualityData, SummaryData, Language } from '@/types';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix Leaflet default icons
import markerIcon2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerIcon from 'leaflet/dist/images/marker-icon.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

delete (L.Icon.Default.prototype as any)._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: markerIcon2x,
  iconUrl: markerIcon,
  shadowUrl: markerShadow,
});

// Pulse animation
const pulse = keyframes`
  0% { transform: scale(1); opacity: 0.8; }
  100% { transform: scale(3); opacity: 0; }
`;

// AQI Marker icon
const createAQIIcon = (aqi: number) => {
  const info = getAQIInfo(aqi);
  return L.divIcon({
    className: 'custom-div-icon',
    html: `<div style="background-color: ${info.color}; color: ${aqi > 200 || aqi < 100 ? '#000' : '#fff'}; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; border: 3px solid white; box-shadow: 0 2px 8px rgba(0,0,0,0.3);">${aqi}</div>`,
    iconSize: [40, 40],
    iconAnchor: [20, 20],
  });
};

// Map bounds updater
function MapBounds({ coords }: { coords: [number, number] }) {
  const map = useMap();
  useEffect(() => {
    map.setView(coords, 11);
  }, [coords, map]);
  return null;
}

// Pulse indicator component
const PulseIndicator = () => (
  <Box
    sx={{
      width: 12,
      height: 12,
      backgroundColor: '#3fb950',
      borderRadius: '50%',
      position: 'relative',
      '&::after': {
        content: '""',
        position: 'absolute',
        width: '100%',
        height: '100%',
        backgroundColor: '#3fb950',
        borderRadius: '50%',
        animation: `${pulse} 2s infinite`,
      },
    }}
  />
);

// Glass card style
const glassCardSx = {
  background: 'rgba(22, 27, 34, 0.7)',
  backdropFilter: 'blur(12px)',
  border: '1px solid rgba(255, 255, 255, 0.1)',
  borderRadius: '16px',
};

export function Home() {
  const { user, isAuthenticated } = useAuth();
  const { toggleTheme } = useThemeContext();
  const muiTheme = useTheme();
  const [lang, setLang] = useState<Language>(localStorage.getItem('lang') as Language || 'ru');
  const [selectedRegion, setSelectedRegion] = useState<string>(user?.city_key || 'astana');
  const [airQuality, setAirQuality] = useState<AirQualityData | null>(null);
  const [summary, setSummary] = useState<SummaryData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [showAQIModal, setShowAQIModal] = useState(false);
  const [compareMode, setCompareMode] = useState(false);
  const [, setCompareRegion] = useState<string | null>(null);
  const [kazakhstanGeo, setKazakhstanGeo] = useState<any>(null);

  const t = TRANSLATIONS[lang];

  // Load initial data
  useEffect(() => {
    const loadInitialData = async () => {
      try {
        const [aqData, summaryData] = await Promise.all([
          airQualityApi.getCurrent(selectedRegion),
          airQualityApi.getSummary(),
        ]);
        setAirQuality(aqData);
        setSummary(summaryData);
        
        try {
          const res = await fetch('https://raw.githubusercontent.com/johan/world.geo.json/master/countries/KAZ.geo.json');
          const geo = await res.json();
          setKazakhstanGeo(geo);
        } catch (e) {
          console.log('Could not load Kazakhstan border');
        }
      } catch (err) {
        setError(t.error);
      } finally {
        setIsLoading(false);
      }
    };

    loadInitialData();
    const interval = setInterval(loadInitialData, 60000);
    return () => clearInterval(interval);
  }, [selectedRegion, t.error]);

  const handleRegionSelect = useCallback((regionKey: string) => {
    if (compareMode) {
      setCompareRegion(regionKey);
      setCompareMode(false);
    } else {
      setSelectedRegion(regionKey);
      localStorage.setItem('region', regionKey);
    }
    setSidebarOpen(false);
  }, [compareMode]);

  const toggleLang = () => {
    const newLang = lang === 'ru' ? 'kk' : 'ru';
    setLang(newLang);
    localStorage.setItem('lang', newLang);
  };

  const filteredRegions = REGIONS.filter(r => {
    const search = searchQuery.toLowerCase();
    return r.name.toLowerCase().includes(search) || r.name_kk.toLowerCase().includes(search);
  });

  const currentRegion = REGIONS.find(r => r.key === selectedRegion) || REGIONS[0];
  const aqiInfo = airQuality ? getAQIInfo(airQuality.current.pollution.aqius) : null;
  const displayName = lang === 'kk' && currentRegion.name_kk ? currentRegion.name_kk : currentRegion.name;

  if (isLoading) {
    return (
      <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: 'background.default' }}>
        <Typography>{t.loading}</Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', bgcolor: 'background.default' }}>
      {/* Header */}
      <AppBar position="sticky" elevation={0}>
        <Toolbar sx={{ justifyContent: 'space-between' }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
            <PulseIndicator />
            <Typography
              variant="h1"
              sx={{
                fontSize: '1.5rem',
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
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <IconButton onClick={() => setSidebarOpen(true)} color="inherit">
              <MenuIcon />
            </IconButton>
            <IconButton onClick={toggleLang} color="inherit">
              <Typography sx={{ fontSize: '0.75rem', fontWeight: 700 }}>{lang}</Typography>
            </IconButton>
            <IconButton onClick={toggleTheme} color="inherit">
              {muiTheme.palette.mode === 'dark' ? <LightModeIcon /> : <DarkModeIcon />}
            </IconButton>
            {isAuthenticated ? (
              <Link to="/profile" style={{ textDecoration: 'none' }}>
                <IconButton color="inherit">
                  <PersonIcon />
                </IconButton>
              </Link>
            ) : (
              <Link to="/login" style={{ textDecoration: 'none' }}>
                <Button variant="outlined" size="small">
                  {t.login}
                </Button>
              </Link>
            )}
          </Box>
        </Toolbar>
      </AppBar>

      {/* Main Content */}
      <Container maxWidth="xl" sx={{ flex: 1, py: 4 }}>
        {error && (
          <Box sx={{ mb: 2, p: 2, bgcolor: 'error.main', borderRadius: 2, color: 'error.contrastText' }}>
            {error}
          </Box>
        )}

        <Grid container spacing={3}>
          {/* Data Panel */}
          <Grid size={{ xs: 12, lg: 4 }}>
            <Card sx={{ ...glassCardSx, height: '100%' }}>
              <CardContent sx={{ p: 3, '&:last-child': { pb: 3 } }}>
                <Typography variant="h6" color="text.secondary">{displayName}</Typography>
                <Box sx={{ display: 'flex', alignItems: 'baseline', gap: 1, mt: 1 }}>
                  <Typography
                    variant="h2"
                    sx={{
                      fontSize: '4rem',
                      fontWeight: 700,
                      color: aqiInfo?.color || '#888',
                    }}
                  >
                    {airQuality?.current.pollution.aqius || '--'}
                  </Typography>
                  <IconButton size="small" onClick={() => setShowAQIModal(true)}>
                    <InfoIcon fontSize="small" sx={{ color: '#8b949e' }} />
                  </IconButton>
                </Box>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                  {t.aqiCaption}
                </Typography>
                <Box sx={{ mb: 3 }}>
                  <Chip
                    label={airQuality ? getAQIText(airQuality.current.pollution.aqius, lang) : t.noData}
                    sx={{
                      backgroundColor: aqiInfo ? `${aqiInfo.color}33` : '#88888833',
                      color: aqiInfo?.color || '#888',
                      fontWeight: 600,
                      borderRadius: '12px',
                    }}
                  />
                </Box>

                <Grid container spacing={1} sx={{ mb: 2 }}>
                  <Grid size={{ xs: 4 }}>
                    <Card sx={{ bgcolor: 'rgba(31, 35, 41, 0.8)', textAlign: 'center', p: 1 }}>
                      <Typography variant="caption" color="text.secondary" sx={{ display: 'block' }}>{t.temp}</Typography>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {airQuality?.current.weather.tp || '--'}°C
                      </Typography>
                    </Card>
                  </Grid>
                  <Grid size={{ xs: 4 }}>
                    <Card sx={{ bgcolor: 'rgba(31, 35, 41, 0.8)', textAlign: 'center', p: 1 }}>
                      <Typography variant="caption" color="text.secondary" sx={{ display: 'block' }}>{t.hum}</Typography>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {airQuality?.current.weather.hu || '--'}%
                      </Typography>
                    </Card>
                  </Grid>
                  <Grid size={{ xs: 4 }}>
                    <Card sx={{ bgcolor: 'rgba(31, 35, 41, 0.8)', textAlign: 'center', p: 1 }}>
                      <Typography variant="caption" color="text.secondary" sx={{ display: 'block' }}>{t.wind}</Typography>
                      <Typography variant="h6" sx={{ fontWeight: 600 }}>
                        {airQuality?.current.weather.ws || '--'} {t.ms}
                      </Typography>
                    </Card>
                  </Grid>
                </Grid>

                <Button
                  variant="outlined"
                  fullWidth
                  onClick={() => setCompareMode(!compareMode)}
                  startIcon={<CompareArrowsIcon />}
                  sx={{ mb: 1 }}
                >
                  {compareMode ? t.close : t.compare}
                </Button>

                {compareMode && (
                  <Typography variant="body2" color="text.secondary" align="center">
                    {lang === 'ru' ? 'Выберите второй регион из списка' : 'Тізімнен екінші аймақты таңдаңыз'}
                  </Typography>
                )}
              </CardContent>
            </Card>
          </Grid>

          {/* Map Panel */}
          <Grid size={{ xs: 12, lg: 8 }}>
            <Card sx={{ ...glassCardSx, height: '400px', overflow: 'hidden' }}>
              <MapContainer
                center={currentRegion.coords}
                zoom={11}
                style={{ height: '400px', width: '100%' }}
                zoomControl={false}
              >
                <TileLayer
                  attribution='&copy; OpenStreetMap & CARTO'
                  url={muiTheme.palette.mode === 'dark'
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'
                  }
                />
                {kazakhstanGeo && (
                  <GeoJSON
                    data={kazakhstanGeo}
                    style={{
                      color: muiTheme.palette.mode === 'dark' ? '#58a6ff' : '#0969da',
                      weight: 2,
                      fill: false,
                      opacity: 0.9
                    }}
                  />
                )}
                {REGIONS.map(region => (
                  <Circle
                    key={region.key}
                    center={region.coords}
                    radius={5000}
                    pathOptions={{
                      color: selectedRegion === region.key ? '#2ea043' : '#888',
                      weight: selectedRegion === region.key ? 3 : 1,
                      fill: false,
                    }}
                    eventHandlers={{
                      click: () => handleRegionSelect(region.key),
                    }}
                  />
                ))}
                {airQuality && (
                  <>
                    <Marker
                      position={currentRegion.coords}
                      icon={createAQIIcon(airQuality.current.pollution.aqius)}
                    />
                    <Circle
                      center={currentRegion.coords}
                      radius={50000}
                      pathOptions={{
                        color: '#2ea043',
                        weight: 2,
                        fill: false,
                      }}
                    />
                    <MapBounds coords={currentRegion.coords} />
                  </>
                )}
              </MapContainer>
            </Card>
          </Grid>
        </Grid>

        {/* Summary Tables */}
        <Grid container spacing={3} sx={{ mt: 3 }}>
          <Grid size={{ xs: 12, md: 6 }}>
            <Card sx={glassCardSx}>
              <CardContent sx={{ p: 3, '&:last-child': { pb: 3 } }}>
                <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
                  {t.dirtyTitle}
                </Typography>
                <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                  {summary?.dirty.slice(0, 10).map((item) => {
                    const info = getAQIInfo(item.aqi);
                    const name = lang === 'kk' && item.name_kk ? item.name_kk : item.region;
                    return (
                      <Box
                        key={item.key}
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'center',
                          p: 1,
                          bgcolor: 'rgba(31, 35, 41, 0.8)',
                          borderRadius: '8px',
                        }}
                      >
                        <Typography variant="body2">{name}</Typography>
                        <Chip
                          label={item.aqi}
                          size="small"
                          sx={{
                            backgroundColor: info.color,
                            color: (item.aqi > 200 || item.aqi < 100) ? '#000' : '#fff',
                            fontWeight: 600,
                            borderRadius: '8px',
                          }}
                        />
                      </Box>
                    );
                  })}
                </Box>
              </CardContent>
            </Card>
          </Grid>

          <Grid size={{ xs: 12, md: 6 }}>
            <Card sx={glassCardSx}>
              <CardContent sx={{ p: 3, '&:last-child': { pb: 3 } }}>
                <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
                  {t.cleanTitle}
                </Typography>
                <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
                  {summary?.clean.slice(0, 10).map((item) => {
                    const info = getAQIInfo(item.aqi);
                    const name = lang === 'kk' && item.name_kk ? item.name_kk : item.region;
                    return (
                      <Box
                        key={item.key}
                        sx={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'center',
                          p: 1,
                          bgcolor: 'rgba(31, 35, 41, 0.8)',
                          borderRadius: '8px',
                        }}
                      >
                        <Typography variant="body2">{name}</Typography>
                        <Chip
                          label={item.aqi}
                          size="small"
                          sx={{
                            backgroundColor: info.color,
                            color: (item.aqi > 200 || item.aqi < 100) ? '#000' : '#fff',
                            fontWeight: 600,
                            borderRadius: '8px',
                          }}
                        />
                      </Box>
                    );
                  })}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        </Grid>

        {/* AQI Legend */}
        <Card sx={{ ...glassCardSx, mt: 3 }}>
          <CardContent sx={{ p: 3, '&:last-child': { pb: 3 } }}>
            <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
              {t.aqiLevels}
            </Typography>
            <Grid container spacing={2}>
              {[
                { range: '0-50', label: t.good, color: '#00e400' },
                { range: '51-100', label: t.moderate, color: '#ffff00' },
                { range: '101-150', label: t.sensitive, color: '#ff7e00' },
                { range: '151-200', label: t.unhealthy, color: '#ff0000' },
                { range: '201-300', label: t.veryUnhealthy, color: '#8f3f97' },
                { range: '300+', label: t.hazardous, color: '#7e0023' },
              ].map((item) => (
                <Grid size={{ xs: 6, sm: 4, md: 2 }} key={item.range}>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <Box
                      sx={{
                        width: 16,
                        height: 16,
                        borderRadius: '50%',
                        backgroundColor: item.color,
                      }}
                    />
                    <Box>
                      <Typography variant="body2" sx={{ fontWeight: 600 }}>
                        {item.range}
                      </Typography>
                      <Typography variant="caption" color="text.secondary">
                        {item.label}
                      </Typography>
                    </Box>
                  </Box>
                </Grid>
              ))}
            </Grid>
          </CardContent>
        </Card>
      </Container>

      {/* Footer */}
      <Box
        component="footer"
        sx={{
          borderTop: '1px solid rgba(255,255,255,0.1)',
          py: 2,
          textAlign: 'center',
          bgcolor: '#0d1117',
        }}
      >
        <Typography variant="body2" color="text.secondary">
          {t.footer}
        </Typography>
      </Box>

      {/* Sidebar */}
      {sidebarOpen && (
        <Box
          sx={{
            position: 'fixed',
            inset: 0,
            bgcolor: 'rgba(0,0,0,0.5)',
            zIndex: 40,
          }}
          onClick={() => setSidebarOpen(false)}
        />
      )}
      <Box
        sx={{
          position: 'fixed',
          top: 0,
          left: 0,
          height: '100%',
          width: 320,
          bgcolor: '#0d1117',
          borderRight: '1px solid rgba(255,255,255,0.1)',
          zIndex: 50,
          transform: sidebarOpen ? 'translateX(0)' : 'translateX(-100%)',
          transition: 'transform 0.2s ease',
          overflowY: 'auto',
        }}
      >
        <Box sx={{ p: 2, borderBottom: '1px solid rgba(255,255,255,0.1)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Typography variant="h6" sx={{ fontWeight: 600 }}>{t.regionsTitle}</Typography>
          <IconButton onClick={() => setSidebarOpen(false)} size="small">
            <CloseIcon sx={{ color: '#f0f6fc' }} />
          </IconButton>
        </Box>
        <Box sx={{ p: 2 }}>
          <TextField
            fullWidth
            size="small"
            placeholder={t.searchPlaceholder}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            sx={{
              '& .MuiInputBase-root': {
                bgcolor: 'rgba(31, 35, 41, 0.8)',
                borderRadius: '12px',
              }
            }}
          />
        </Box>
        <List sx={{ py: 1 }}>
          {filteredRegions.map((region) => {
            const summaryItem = summary?.dirty.find(d => d.key === region.key) || 
                               summary?.clean.find(c => c.key === region.key);
            const aqi = summaryItem?.aqi;
            const info = aqi ? getAQIInfo(aqi) : null;
            const name = lang === 'kk' && region.name_kk ? region.name_kk : region.name;
            
            return (
              <ListItem key={region.key} disablePadding sx={{ px: 1 }}>
                <ListItemButton
                  onClick={() => handleRegionSelect(region.key)}
                  selected={selectedRegion === region.key}
                  sx={{
                    borderRadius: '12px',
                    mb: 0.5,
                    justifyContent: 'space-between',
                  }}
                >
                  <Typography variant="body2">{name}</Typography>
                  {aqi && (
                    <Chip
                      label={aqi}
                      size="small"
                      sx={{
                        backgroundColor: info?.color || '#888',
                        color: (aqi > 200 || aqi < 100) ? '#000' : '#fff',
                        fontWeight: 600,
                        minWidth: '32px',
                        borderRadius: '8px',
                      }}
                    />
                  )}
                </ListItemButton>
              </ListItem>
            );
          })}
        </List>
      </Box>

      {/* AQI Info Modal */}
      <Dialog
        open={showAQIModal}
        onClose={() => setShowAQIModal(false)}
        maxWidth="sm"
        fullWidth
        slotProps={{
          paper: {
            sx: {
              ...glassCardSx,
              background: 'rgba(22, 27, 34, 0.95)',
            }
          }
        }}
      >
        <DialogTitle sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Typography variant="h6" sx={{ fontWeight: 600 }}>{t.aqiLevels}</Typography>
          <IconButton onClick={() => setShowAQIModal(false)} size="small">
            <CloseIcon sx={{ color: '#f0f6fc' }} />
          </IconButton>
        </DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, py: 1 }}>
            {[
              { range: '0-50', label: t.good, color: '#00e400', desc: lang === 'ru' ? 'Качество воздуха удовлетворительное' : 'Ауа сапасы қанағаттанарлық' },
              { range: '51-100', label: t.moderate, color: '#ffff00', desc: lang === 'ru' ? 'Качество воздуха приемлемое' : 'Ауа сапасы қолайлы' },
              { range: '101-150', label: t.sensitive, color: '#ff7e00', desc: lang === 'ru' ? 'Чувствительным группам нездорово' : 'Сезімтал топтарға зиянды' },
              { range: '151-200', label: t.unhealthy, color: '#ff0000', desc: lang === 'ru' ? 'Всем нездорово' : 'Барлығына зиянды' },
              { range: '201-300', label: t.veryUnhealthy, color: '#8f3f97', desc: lang === 'ru' ? 'Очень нездорово' : 'Өте зиянды' },
              { range: '300+', label: t.hazardous, color: '#7e0023', desc: lang === 'ru' ? 'Опасно' : 'Қауіпті' },
            ].map((item) => (
              <Box key={item.range} sx={{ display: 'flex', gap: 2, alignItems: 'flex-start', p: 2, bgcolor: 'rgba(31, 35, 41, 0.8)', borderRadius: '12px' }}>
                <Chip
                  label={item.range}
                  sx={{
                    backgroundColor: item.color,
                    color: (item.range === '51-100' || item.range === '0-50') ? '#000' : '#fff',
                    fontWeight: 600,
                    minWidth: '50px',
                    borderRadius: '8px',
                    shrink: 0,
                  }}
                />
                <Box>
                  <Typography sx={{ fontWeight: 600 }}>{item.label}</Typography>
                  <Typography variant="body2" color="text.secondary">{item.desc}</Typography>
                </Box>
              </Box>
            ))}
          </Box>
        </DialogContent>
      </Dialog>
    </Box>
  );
}
