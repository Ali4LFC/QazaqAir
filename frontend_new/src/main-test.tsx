import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'

function TestApp() {
  return <div style={{ padding: 20, background: '#0d1117', color: 'white', minHeight: '100vh' }}>Test App Works!</div>
}

const rootElement = document.getElementById('root')
if (rootElement) {
  createRoot(rootElement).render(
    <StrictMode>
      <TestApp />
    </StrictMode>
  )
  console.log('Test app rendered')
} else {
  console.error('Root element not found')
}
