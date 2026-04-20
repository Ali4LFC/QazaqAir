#!/bin/bash

# UFW Firewall Configuration for QazaqAir
echo "Configuring UFW firewall rules..."

# Reset existing rules
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (custom port)
ufw allow 2222/tcp comment "SSH Custom Port"

# Allow HTTP/HTTPS
ufw allow 80/tcp comment "HTTP"
ufw allow 443/tcp comment "HTTPS"

# Allow application ports
ufw allow 3000/tcp comment "Grafana"
ufw allow 3001/tcp comment "Frontend New"
ufw allow 8000/tcp comment "Backend API"
ufw allow 8080/tcp comment "Zabbix Web"
ufw allow 8082/tcp comment "Graphite"
ufw allow 9000/tcp comment "Portainer"
ufw allow 9090/tcp comment "Prometheus"
ufw allow 9093/tcp comment "AlertManager"
ufw allow 9115/tcp comment "Blackbox Exporter"
ufw allow 10051/tcp comment "Zabbix Server"

# Allow monitoring network
ufw allow from 172.16.0.0/12 comment "Monitoring Network"

# Allow Docker networks
ufw allow from 172.17.0.0/16 comment "Docker Bridge"
ufw allow from 172.18.0.0/16 comment "Docker Custom"

# Enable logging
ufw logging on

# Enable firewall
ufw --force enable

echo "UFW firewall configured successfully!"
ufw status verbose
