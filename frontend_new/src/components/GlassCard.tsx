import { Paper, type PaperProps, styled } from '@mui/material';

export const GlassCard = styled(Paper)<PaperProps>(({ theme }) => ({
  background: theme.palette.mode === 'dark' 
    ? 'rgba(22, 27, 34, 0.7)' 
    : 'rgba(255, 255, 255, 0.8)',
  backdropFilter: 'blur(12px)',
  border: `1px solid ${theme.palette.mode === 'dark' 
    ? 'rgba(255, 255, 255, 0.1)' 
    : 'rgba(0, 0, 0, 0.08)'}`,
  borderRadius: '16px',
  overflow: 'hidden',
}));

export default GlassCard;
