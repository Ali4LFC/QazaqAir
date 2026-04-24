# Terraform Main Configuration for QazaqAir Infrastructure
# Module 9: IaC - Infrastructure as Code

# =============================================================================
# LOCAL VARIABLES
# =============================================================================

locals {
  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  container_prefix = "${var.project_name}"
}

# =============================================================================
# DOCKER NETWORKS
# =============================================================================

resource "docker_network" "app_network" {
  name   = "${local.container_prefix}-network"
  driver = "bridge"

  ipam_config {
    subnet  = var.network_subnet
    gateway = var.network_gateway
  }

  labels {
    label = "project"
    value = var.project_name
  }
}

# =============================================================================
# DOCKER VOLUMES
# =============================================================================

resource "docker_volume" "postgres_data" {
  name = "${local.container_prefix}-postgres-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "n8n_data" {
  name = "${local.container_prefix}-n8n-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "prometheus_data" {
  name = "${local.container_prefix}-prometheus-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "grafana_data" {
  name = "${local.container_prefix}-grafana-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "alertmanager_data" {
  name = "${local.container_prefix}-alertmanager-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "jenkins_data" {
  name = "${local.container_prefix}-jenkins-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "portainer_data" {
  name = "${local.container_prefix}-portainer-data"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "nagios_etc" {
  name = "${local.container_prefix}-nagios-etc"

  labels {
    label = "project"
    value = var.project_name
  }
}

resource "docker_volume" "nagios_var" {
  name = "${local.container_prefix}-nagios-var"

  labels {
    label = "project"
    value = var.project_name
  }
}

# =============================================================================
# CORE SERVICES - DATABASE
# =============================================================================

resource "docker_container" "db" {
  name  = "${local.container_prefix}-db-1"
  image = "postgres:15-alpine"

  restart = "always"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["db"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "database"
  }

  labels {
    label = "environment"
    value = var.environment
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

# =============================================================================
# CORE SERVICES - BACKEND
# =============================================================================

resource "docker_container" "backend" {
  name  = "${local.container_prefix}-backend-1"
  image = "${local.container_prefix}-backend:latest"

  restart = "always"

  build {
    context = "${path.root}/.."
    dockerfile = "Dockerfile"
  }

  env = [
    "DATABASE_URL=postgresql://${var.db_user}:${var.db_password}@db:5432/${var.db_name}",
    "SSL_CERTFILE=/app/backend/certs/cert.pem",
    "SSL_KEYFILE=/app/backend/certs/key.pem"
  ]

  ports {
    internal = 8000
    external = 8000
  }

  ports {
    internal = 2222
    external = var.ssh_port
  }

  volumes {
    host_path      = "${path.root}/../backend"
    container_path = "/app/backend"
  }

  volumes {
    host_path      = "${path.root}/../backend/certs"
    container_path = "/app/backend/certs"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["backend"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "backend"
  }

  depends_on = [docker_container.db]
}

# =============================================================================
# CORE SERVICES - FRONTEND
# =============================================================================

resource "docker_container" "frontend" {
  name  = "${local.container_prefix}-frontend-1"
  image = "${local.container_prefix}-frontend:latest"

  restart = "always"

  build {
    context = "${path.root}/../frontend_new"
    dockerfile = "Dockerfile"
  }

  ports {
    internal = 80
    external = 3001
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["frontend"].memory
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "frontend"
  }
}

# =============================================================================
# WEB SERVER - NGINX
# =============================================================================

resource "docker_container" "nginx" {
  name  = "${local.container_prefix}-app-1"
  image = "nginx:alpine"

  restart = "always"

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  volumes {
    host_path      = "${path.root}/../nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  volumes {
    host_path      = "${path.root}/../backend/certs"
    container_path = "/etc/nginx/ssl"
    read_only      = true
  }

  volumes {
    host_path      = "${path.root}/../html"
    container_path = "/usr/share/nginx/html"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["nginx"].memory
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "nginx"
  }

  depends_on = [
    docker_container.backend,
    docker_container.frontend
  ]
}

# =============================================================================
# MONITORING - PROMETHEUS
# =============================================================================

resource "docker_container" "prometheus" {
  name  = "${local.container_prefix}-prometheus-1"
  image = "prom/prometheus:latest"

  restart = "always"

  user = "root"

  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--web.console.libraries=/usr/share/prometheus/console_libraries",
    "--web.console.templates=/usr/share/prometheus/consoles",
    "--storage.tsdb.retention.time=30d",
    "--storage.tsdb.retention.size=10GB"
  ]

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = "${path.root}/../monitoring/prometheus/prometheus-enhanced.yml"
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["prometheus"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "prometheus"
  }
}

# =============================================================================
# MONITORING - GRAFANA
# =============================================================================

resource "docker_container" "grafana" {
  name  = "${local.container_prefix}-grafana-1"
  image = "grafana/grafana:latest"

  restart = "always"

  user = "root"

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_USERS_ALLOW_SIGN_UP=false",
    "GF_RENDERING_ENABLED=false",
    "GF_IMAGE_RENDERER_PLUGIN_ENABLED=false",
    "GF_PLUGINS_ENABLE_ALPHA=false",
    "GF_FEATURE_TOGGLES_ENABLE=publicDashboards"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["grafana"].memory
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "grafana"
  }

  depends_on = [docker_container.prometheus]
}

# =============================================================================
# MONITORING - NODE EXPORTER
# =============================================================================

resource "docker_container" "node_exporter" {
  name  = "${local.container_prefix}-node-exporter"
  image = "prom/node-exporter:latest"

  restart = "unless-stopped"

  command = [
    "--path.procfs=/host/proc",
    "--path.rootfs=/rootfs",
    "--path.sysfs=/host/sys",
    "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)",
    "--collector.netdev.device-exclude=^(docker|veth|br-|lo)($$|:)",
    "--collector.netclass.ignored-devices=^(docker|veth|br-|lo)($$|:)"
  ]

  ports {
    internal = 9100
    external = 9100
  }

  volumes {
    host_path      = "/proc"
    container_path = "/host/proc"
    read_only      = true
  }

  volumes {
    host_path      = "/sys"
    container_path = "/host/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  volumes {
    host_path      = "/etc/hostname"
    container_path = "/etc/nodename"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "128M"
    cpu_shares = 128
  }

  labels {
    label = "service"
    value = "node-exporter"
  }
}

# =============================================================================
# MONITORING - CADVISOR
# =============================================================================

resource "docker_container" "cadvisor" {
  name  = "${local.container_prefix}-cadvisor"
  image = "gcr.io/cadvisor/cadvisor:latest"

  restart = "unless-stopped"

  command = [
    "--port=8080",
    "--docker_only=true",
    "--disable_metrics=percpu"
  ]

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "256M"
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "cadvisor"
  }
}

# =============================================================================
# MONITORING - ZABBIX
# =============================================================================

resource "docker_container" "zabbix_db" {
  name  = "${local.container_prefix}-zabbix-db"
  image = "postgres:15-alpine"

  restart = "always"

  env = [
    "POSTGRES_USER=${var.zabbix_db_user}",
    "POSTGRES_PASSWORD=${var.zabbix_db_password}",
    "POSTGRES_DB=${var.zabbix_db_name}"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "512M"
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "zabbix-db"
  }
}

resource "docker_container" "zabbix_server" {
  name  = "${local.container_prefix}-zabbix-server"
  image = "zabbix/zabbix-server-pgsql:alpine-6.4-latest"

  restart = "always"

  env = [
    "DB_SERVER_HOST=${local.container_prefix}-zabbix-db",
    "POSTGRES_USER=${var.zabbix_db_user}",
    "POSTGRES_PASSWORD=${var.zabbix_db_password}",
    "POSTGRES_DB=${var.zabbix_db_name}"
  ]

  ports {
    internal = 10051
    external = 10051
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["zabbix_server"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "zabbix-server"
  }

  depends_on = [docker_container.zabbix_db]
}

resource "docker_container" "zabbix_web" {
  name  = "${local.container_prefix}-zabbix-web"
  image = "zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest"

  restart = "always"

  env = [
    "ZBX_SERVER_HOST=${local.container_prefix}-zabbix-server",
    "DB_SERVER_HOST=${local.container_prefix}-zabbix-db",
    "POSTGRES_USER=${var.zabbix_db_user}",
    "POSTGRES_PASSWORD=${var.zabbix_db_password}",
    "POSTGRES_DB=${var.zabbix_db_name}",
    "PHP_TZ=Asia/Almaty"
  ]

  ports {
    internal = 8080
    external = 8086
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["zabbix_web"].memory
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "zabbix-web"
  }

  depends_on = [docker_container.zabbix_server]
}

# =============================================================================
# MONITORING - NAGIOS
# =============================================================================

resource "docker_container" "nagios" {
  name  = "${local.container_prefix}-nagios-1"
  image = "jasonrivers/nagios:latest"

  restart = "unless-stopped"

  env = [
    "NAGIOSADMIN_USER=${var.nagios_admin_user}",
    "NAGIOSADMIN_PASS=${var.nagios_admin_password}",
    "NAGIOS_TIMEZONE=Asia/Almaty"
  ]

  ports {
    internal = 80
    external = 8083
  }

  volumes {
    volume_name    = docker_volume.nagios_etc.name
    container_path = "/opt/nagios/etc"
  }

  volumes {
    volume_name    = docker_volume.nagios_var.name
    container_path = "/opt/nagios/var"
  }

  volumes {
    host_path      = "${path.root}/../monitoring/nagios/nagios.cfg"
    container_path = "/opt/nagios/etc/nagios.cfg"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["nagios"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "nagios"
  }

  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:80"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
    start_period = "60s"
  }
}

# =============================================================================
# AUTOMATION - N8N
# =============================================================================

resource "docker_container" "n8n" {
  name  = "${local.container_prefix}-n8n-1"
  image = "n8nio/n8n:latest"

  restart = "always"

  env = [
    "DB_TYPE=postgresdb",
    "DB_POSTGRESDB_HOST=db",
    "DB_POSTGRESDB_PORT=5432",
    "DB_POSTGRESDB_DATABASE=${var.db_name}",
    "DB_POSTGRESDB_USER=${var.db_user}",
    "DB_POSTGRESDB_PASSWORD=${var.db_password}",
    "N8N_HOST=localhost",
    "N8N_PORT=5678",
    "WEBHOOK_URL=http://localhost/n8n/"
  ]

  ports {
    internal = 5678
    external = 5678
  }

  volumes {
    volume_name    = docker_volume.n8n_data.name
    container_path = "/home/node/.n8n"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["n8n"].memory
    cpu_shares = 512
  }

  labels {
    label = "service"
    value = "n8n"
  }

  depends_on = [docker_container.db]
}

# =============================================================================
# AUTOMATION - JENKINS
# =============================================================================

resource "docker_container" "jenkins" {
  name  = "${local.container_prefix}-jenkins-1"
  image = "jenkins/jenkins:lts-jdk17"

  restart = "always"
  user    = "root"

  ports {
    internal = 8080
    external = 8085
  }

  ports {
    internal = 50000
    external = 50000
  }

  volumes {
    volume_name    = docker_volume.jenkins_data.name
    container_path = "/var/jenkins_home"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = var.resources_limits["jenkins"].memory
    cpu_shares = 768
  }

  labels {
    label = "service"
    value = "jenkins"
  }
}

# =============================================================================
# MANAGEMENT - PORTAINER
# =============================================================================

resource "docker_container" "portainer" {
  name  = "${local.container_prefix}-portainer"
  image = "portainer/portainer-ce:latest"

  restart = "always"

  ports {
    internal = 9000
    external = 9000
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.portainer_data.name
    container_path = "/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "128M"
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "portainer"
  }
}

# =============================================================================
# MONITORING - ALERTMANAGER
# =============================================================================

resource "docker_container" "alertmanager" {
  name  = "${local.container_prefix}-alertmanager"
  image = "prom/alertmanager:latest"

  restart = "unless-stopped"

  command = [
    "--config.file=/etc/alertmanager/alertmanager.yml",
    "--storage.path=/alertmanager"
  ]

  ports {
    internal = 9093
    external = 9093
  }

  volumes {
    host_path      = "${path.root}/../monitoring/alertmanager/alertmanager.yml"
    container_path = "/etc/alertmanager/alertmanager.yml"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.alertmanager_data.name
    container_path = "/alertmanager"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "256M"
    cpu_shares = 256
  }

  labels {
    label = "service"
    value = "alertmanager"
  }
}

# =============================================================================
# MONITORING - BLACKBOX EXPORTER
# =============================================================================

resource "docker_container" "blackbox_exporter" {
  name  = "${local.container_prefix}-blackbox-exporter"
  image = "prom/blackbox-exporter:latest"

  restart = "unless-stopped"

  command = [
    "--config.file=/config/blackbox.yml"
  ]

  ports {
    internal = 9115
    external = 9115
  }

  volumes {
    host_path      = "${path.root}/../monitoring/blackbox"
    container_path = "/config"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  resources {
    memory = "128M"
    cpu_shares = 128
  }

  labels {
    label = "service"
    value = "blackbox-exporter"
  }
}
