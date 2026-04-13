import { StrictMode, useState, useEffect, useMemo } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { ThemeProvider } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import '@fontsource/outfit/300.css';
import '@fontsource/outfit/400.css';
import '@fontsource/outfit/500.css';
import '@fontsource/outfit/600.css';
import '@fontsource/outfit/700.css';
import './index.css'
import { createAppTheme } from '@/theme'
import type { Theme } from '@/types';

// Simple test without Auth
function DebugApp() {
  console.log('DebugApp render start')
  const [theme, setTheme] = useState<Theme>('dark');
  
  const muiTheme = useMemo(() => {
    console.log('Creating theme:', theme)
    return createAppTheme(theme)
  }, [theme]);

  console.log('DebugApp got theme')
  
  return (
    <ThemeProvider theme={muiTheme}>
      <CssBaseline />
      <BrowserRouter>
        <div style={{ padding: 20, background: '#0d1117', color: 'white', minHeight: '100vh' }}>
          <h1>Debug Mode - Theme loaded!</h1>
          <p>Theme: {theme}</p>
          <button onClick={() => setTheme(t => t === 'dark' ? 'light' : 'dark')}>
            Toggle Theme
          </button>
        </div>
      </BrowserRouter>
    </ThemeProvider>
  )
}

const rootElement = document.getElementById('root')
if (rootElement) {
  console.log('Starting render...')
  try {
    createRoot(rootElement).render(
      <StrictMode>
        <DebugApp />
      </StrictMode>,
    )
    console.log('Render completed')
  } catch (err) {
    console.error('Render error:', err)
    rootElement.innerHTML = '<pre style="color:red">' + String(err) + '</pre>'
  }
} else {
  console.error('Root element not found')
}
