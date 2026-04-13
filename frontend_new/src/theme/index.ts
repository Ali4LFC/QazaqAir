import { createTheme } from '@mui/material/styles';
import type { ThemeOptions } from '@mui/material/styles';
import { ruRU } from '@mui/material/locale';

// AQI Colors
export const aqiColors = {
  good: '#00e400',
  moderate: '#ffff00',
  unhealthySensitive: '#ff7e00',
  unhealthy: '#ff0000',
  veryUnhealthy: '#8f3f97',
  hazardous: '#7e0023',
};

// Glassmorphism styles
const glassStyles = {
  background: 'rgba(22, 27, 34, 0.7)',
  backdropFilter: 'blur(12px)',
  border: '1px solid rgba(255, 255, 255, 0.1)',
  borderRadius: '16px',
};

// Dark theme configuration
const darkThemeOptions: ThemeOptions = {
  palette: {
    mode: 'dark',
    background: {
      default: '#0d1117',
      paper: 'rgba(22, 27, 34, 0.7)',
    },
    primary: {
      main: '#58a6ff',
      light: '#79b8ff',
      dark: '#388bfd',
    },
    secondary: {
      main: '#bc85ff',
      light: '#d4b8ff',
      dark: '#a668ff',
    },
    text: {
      primary: '#f0f6fc',
      secondary: '#8b949e',
    },
    divider: 'rgba(255, 255, 255, 0.1)',
    error: { main: '#ff0000' },
    warning: { main: '#ff7e00' },
    success: { main: '#00e400' },
    info: { main: '#8f3f97' },
  },
  typography: {
    fontFamily: "'Outfit', 'Roboto', 'Helvetica', 'Arial', sans-serif",
    h1: {
      fontWeight: 700,
      fontSize: '1.8rem',
    },
    h2: {
      fontWeight: 600,
      fontSize: '1.5rem',
    },
    h3: {
      fontWeight: 600,
      fontSize: '1.2rem',
    },
    h4: {
      fontWeight: 600,
      fontSize: '1rem',
    },
    button: {
      textTransform: 'none',
      fontWeight: 500,
    },
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        '*': {
          scrollbarWidth: 'thin',
          scrollbarColor: '#30363d #0d1117',
        },
        '*::-webkit-scrollbar': {
          width: '6px',
        },
        '*::-webkit-scrollbar-track': {
          background: '#0d1117',
        },
        '*::-webkit-scrollbar-thumb': {
          background: '#30363d',
          borderRadius: '10px',
        },
        '*::-webkit-scrollbar-thumb:hover': {
          background: '#484f58',
        },
        body: {
          backgroundColor: '#0d1117',
          minHeight: '100vh',
        },
      },
    },
    MuiPaper: {
      styleOverrides: {
        root: {
          ...glassStyles,
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          ...glassStyles,
          overflow: 'hidden',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          padding: '8px 16px',
          transition: 'all 0.2s ease',
        },
        contained: {
          background: 'rgba(88, 166, 255, 0.2)',
          border: '1px solid rgba(88, 166, 255, 0.3)',
          '&:hover': {
            background: 'rgba(88, 166, 255, 0.3)',
          },
        },
        outlined: {
          borderColor: 'rgba(255, 255, 255, 0.2)',
          background: 'rgba(22, 27, 34, 0.5)',
          '&:hover': {
            borderColor: '#58a6ff',
            background: 'rgba(88, 166, 255, 0.1)',
          },
        },
      },
    },
    MuiIconButton: {
      styleOverrides: {
        root: {
          borderRadius: '50%',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          background: 'rgba(22, 27, 34, 0.7)',
          width: '36px',
          height: '36px',
          padding: 0,
          '&:hover': {
            background: 'rgba(88, 166, 255, 0.2)',
            borderColor: 'rgba(88, 166, 255, 0.5)',
          },
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            borderRadius: '12px',
            background: 'rgba(31, 35, 41, 0.8)',
            border: '1px solid rgba(255, 255, 255, 0.1)',
            '& fieldset': {
              borderColor: 'rgba(255, 255, 255, 0.1)',
            },
            '&:hover fieldset': {
              borderColor: 'rgba(88, 166, 255, 0.5)',
            },
            '&.Mui-focused fieldset': {
              borderColor: '#58a6ff',
            },
          },
        },
      },
    },
    MuiInputBase: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
        },
      },
    },
    MuiSelect: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          background: 'rgba(31, 35, 41, 0.8)',
          '& .MuiOutlinedInput-notchedOutline': {
            borderColor: 'rgba(255, 255, 255, 0.1)',
          },
          '&:hover .MuiOutlinedInput-notchedOutline': {
            borderColor: 'rgba(88, 166, 255, 0.5)',
          },
          '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
            borderColor: '#58a6ff',
          },
        },
      },
    },
    MuiDialog: {
      styleOverrides: {
        paper: {
          ...glassStyles,
          background: 'rgba(22, 27, 34, 0.95)',
        },
      },
    },
    MuiDrawer: {
      styleOverrides: {
        paper: {
          ...glassStyles,
          background: 'rgba(22, 27, 34, 0.95)',
        },
      },
    },
    MuiListItem: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          marginBottom: '8px',
          background: 'rgba(22, 27, 34, 0.5)',
          border: '1px solid rgba(255, 255, 255, 0.05)',
          '&:hover': {
            background: 'rgba(88, 166, 255, 0.1)',
            borderColor: 'rgba(88, 166, 255, 0.3)',
          },
          '&.Mui-selected': {
            background: 'rgba(88, 166, 255, 0.2)',
            borderColor: '#58a6ff',
          },
        },
      },
    },
    MuiChip: {
      styleOverrides: {
        root: {
          borderRadius: '12px',
          fontWeight: 600,
        },
      },
    },
    MuiAppBar: {
      styleOverrides: {
        root: {
          background: 'rgba(13, 17, 23, 0.8)',
          backdropFilter: 'blur(12px)',
          borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
        },
      },
    },
    MuiLinearProgress: {
      styleOverrides: {
        root: {
          borderRadius: '4px',
        },
      },
    },
  },
};

// Light theme
const lightThemeOptions: ThemeOptions = {
  palette: {
    mode: 'light',
    background: {
      default: '#f6f8fa',
      paper: 'rgba(255, 255, 255, 0.8)',
    },
    primary: {
      main: '#58a6ff',
      light: '#79b8ff',
      dark: '#388bfd',
    },
    secondary: {
      main: '#bc85ff',
      light: '#d4b8ff',
      dark: '#a668ff',
    },
    text: {
      primary: '#24292f',
      secondary: '#57606a',
    },
    divider: 'rgba(0, 0, 0, 0.08)',
  },
  components: {
    ...darkThemeOptions.components,
    MuiPaper: {
      styleOverrides: {
        root: {
          background: 'rgba(255, 255, 255, 0.8)',
          backdropFilter: 'blur(12px)',
          border: '1px solid rgba(0, 0, 0, 0.08)',
          borderRadius: '16px',
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          background: 'rgba(255, 255, 255, 0.8)',
          backdropFilter: 'blur(12px)',
          border: '1px solid rgba(0, 0, 0, 0.08)',
          borderRadius: '16px',
        },
      },
    },
    MuiIconButton: {
      styleOverrides: {
        root: {
          border: '1px solid rgba(0, 0, 0, 0.08)',
          background: 'rgba(255, 255, 255, 0.7)',
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            background: '#f6f8fa',
            border: '1px solid rgba(0, 0, 0, 0.08)',
          },
        },
      },
    },
  },
};

export const createAppTheme = (mode: 'light' | 'dark') => {
  const options = mode === 'light' ? lightThemeOptions : darkThemeOptions;
  return createTheme(options, ruRU);
};

export default createAppTheme;
