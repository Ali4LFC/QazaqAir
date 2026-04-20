#!/bin/bash

# SSL Certificate Setup with Let's Encrypt for QazaqAir
DOMAIN="qazaqair.example.com"  # Replace with actual domain
EMAIL="admin@qazaqair.example.com"

echo "Setting up SSL certificates for $DOMAIN..."

# Install Certbot
apt-get update
apt-get install -y certbot python3-certbot-nginx

# Create Nginx SSL configuration
cat > /etc/nginx/sites-available/qazaqair-ssl << 'EOF'
server {
    listen 80;
    server_name qazaqair.example.com;
    
    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name qazaqair.example.com;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/qazaqair.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/qazaqair.example.com/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Proxy for backend API
    location /api/ {
        proxy_pass http://qazaqair-backend-1:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }

    # Proxy for frontend_new (React app)
    location /app/ {
        proxy_pass http://qazaqair-frontend-1/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }

    # Main website
    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }

    # Proxy for n8n
    location /n8n/ {
        proxy_pass http://qazaqair-n8n-1:5678/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }

    # Proxy for Grafana
    location /grafana/ {
        proxy_pass http://qazaqair-grafana-1:3000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ssl_verify off;
    }
}
EOF

# Get SSL certificate
certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# Setup auto-renewal
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

# Test SSL configuration
nginx -t && systemctl reload nginx

echo "SSL setup completed for $DOMAIN"
echo "Certificate location: /etc/letsencrypt/live/$DOMAIN/"
echo "Auto-renewal configured in crontab"
