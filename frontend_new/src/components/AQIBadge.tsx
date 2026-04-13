import { Chip, ChipProps } from '@mui/material';
import { getAQIColor, getAQILabel } from '@/lib/utils';

interface AQIBadgeProps extends Omit<ChipProps, 'label' | 'color'> {
  aqi: number | null;
  lang?: 'ru' | 'kk';
  size?: 'small' | 'medium' | 'large';
}

export const AQIBadge = ({ aqi, lang = 'ru', size = 'medium', ...props }: AQIBadgeProps) => {
  const color = aqi !== null ? getAQIColor(aqi) : '#8b949e';
  const label = aqi !== null ? aqi.toString() : '--';
  
  const sizeStyles = {
    small: { fontSize: '0.75rem', padding: '2px 8px', minWidth: '32px' },
    medium: { fontSize: '0.875rem', padding: '6px 10px', minWidth: '38px' },
    large: { fontSize: '1rem', padding: '8px 14px', minWidth: '50px' },
  };
  
  return (
    <Chip
      label={label}
      sx={{
        ...sizeStyles[size],
        backgroundColor: color,
        color: aqi !== null && (aqi < 100 || aqi > 200) ? '#000' : '#fff',
        fontWeight: 700,
        borderRadius: '12px',
        '& .MuiChip-label': {
          padding: 0,
        },
      }}
      {...props}
    />
  );
};

export default AQIBadge;
