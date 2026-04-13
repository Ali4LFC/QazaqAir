import { Box, Typography, keyframes } from '@mui/material';

const pulseAnimation = keyframes`
  0% {
    transform: scale(1);
    opacity: 0.8;
  }
  100% {
    transform: scale(3);
    opacity: 0;
  }
`;

const PulseIcon = () => (
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
        animation: `${pulseAnimation} 2s infinite`,
      },
    }}
  />
);

export const Logo = () => {
  return (
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
      <PulseIcon />
      <Typography
        variant="h1"
        sx={{
          fontSize: '1.8rem',
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
  );
};

export default Logo;
