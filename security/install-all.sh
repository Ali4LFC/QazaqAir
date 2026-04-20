#!/bin/bash

# Complete Security and Infrastructure Setup for QazaqAir
set -e

echo "🚀 Starting QazaqAir Infrastructure Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   exit 1
fi

# Update system
print_status "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install required packages
print_status "Installing required packages..."
sudo apt-get install -y \
    ufw \
    fail2ban \
    certbot \
    python3-certbot-nginx \
    postgresql-client \
    htop \
    curl \
    wget \
    git \
    docker.io \
    docker-compose \
    nginx

# Start and enable services
print_status "Starting and enabling services..."
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Setup Firewall
print_status "Setting up firewall..."
sudo chmod +x security/ufw-rules.sh
sudo ./security/ufw-rules.sh

# Setup Fail2Ban
print_status "Configuring Fail2Ban..."
sudo cp security/jail.local /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

# Setup Database Privileges
print_status "Setting up database privileges..."
if command -v psql &> /dev/null; then
    PGPASSWORD=password psql -h localhost -U user -d airmonitor -f security/setup-db-privileges.sql
    print_status "Database privileges configured"
else
    print_warning "PostgreSQL client not found. Please run database setup manually"
fi

# Setup SSL (optional - requires domain)
read -p "Do you want to setup SSL with Let's Encrypt? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Setting up SSL..."
    read -p "Enter your domain name: " DOMAIN
    read -p "Enter your email: " EMAIL
    
    # Update SSL script with actual domain
    sed -i "s/qazaqair.example.com/$DOMAIN/g" security/setup-ssl.sh
    sed -i "s/admin@qazaqair.example.com/$EMAIL/g" security/setup-ssl.sh
    
    sudo chmod +x security/setup-ssl.sh
    sudo ./security/setup-ssl.sh
fi

# Create monitoring network
print_status "Creating Docker networks..."
docker network create monitoring_network 2>/dev/null || true
docker network create automation_network 2>/dev/null || true

# Start monitoring stack
print_status "Starting monitoring stack..."
cd monitoring
docker-compose up -d
cd ..

# Start automation stack (optional)
read -p "Do you want to setup automation stack (Jenkins, OPA, etc.)? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Starting automation stack..."
    cd automation
    docker-compose up -d
    cd ..
fi

# Start cAdvisor and exporters
print_status "Starting cAdvisor and exporters..."
cd monitoring
docker-compose -f docker-compose-cadvisor.yml up -d
cd ..

# Setup backup cron job
print_status "Setting up backup cron job..."
(crontab -l 2>/dev/null; echo "0 2 * * * cd /path/to/qazaqair && python -m backend.app.services.backup_service") | crontab -

# Print summary
echo ""
print_status "✅ Infrastructure setup completed!"
echo ""
echo "📊 Access URLs:"
echo "  - Main App: http://localhost"
echo "  - Frontend New: http://localhost:3001"
echo "  - Grafana: http://localhost:3000 (admin/admin)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Zabbix: http://localhost:8080"
echo "  - Portainer: http://localhost:9000"
echo "  - N8N: http://localhost/n8n"
echo ""
echo "🔧 Management Commands:"
echo "  - View logs: docker-compose logs -f"
echo "  - Stop services: docker-compose down"
echo "  - Restart services: docker-compose restart"
echo ""
echo "🛡️ Security Status:"
echo "  - Firewall: $(sudo ufw status | head -1)"
echo "  - Fail2Ban: $(sudo systemctl is-active fail2ban)"
echo "  - Docker: $(sudo systemctl is-active docker)"
echo ""
print_warning "Remember to:"
echo "  1. Change default passwords"
echo "  2. Configure proper domain for SSL"
echo "  3. Setup proper backup retention"
echo "  4. Review and update firewall rules"
echo "  5. Monitor system resources"
