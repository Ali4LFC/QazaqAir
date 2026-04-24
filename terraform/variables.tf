# Terraform Variables for QazaqAir Infrastructure
# Module 9: IaC - Infrastructure as Code

# =============================================================================
# INFRASTRUCTURE SETTINGS
# =============================================================================

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "qazaqair"
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "docker_host" {
  description = "Docker daemon connection string"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

# =============================================================================
# NETWORK SETTINGS
# =============================================================================

variable "network_subnet" {
  description = "Subnet for Docker network"
  type        = string
  default     = "172.20.0.0/16"
}

variable "network_gateway" {
  description = "Gateway for Docker network"
  type        = string
  default     = "172.20.0.1"
}

# =============================================================================
# DATABASE SETTINGS
# =============================================================================

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "airmonitor"
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "user"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "zabbix_db_name" {
  description = "Zabbix database name"
  type        = string
  default     = "zabbix"
}

variable "zabbix_db_user" {
  description = "Zabbix database username"
  type        = string
  default     = "zabbix"
}

variable "zabbix_db_password" {
  description = "Zabbix database password"
  type        = string
  sensitive   = true
  default     = "zabbix_password"
}

# =============================================================================
# SECURITY SETTINGS
# =============================================================================

variable "ssh_port" {
  description = "SSH port for backend access"
  type        = number
  default     = 2222
}

variable "enable_ssl" {
  description = "Enable SSL/TLS certificates"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for SSL certificates"
  type        = string
  default     = "localhost"
}

variable "admin_email" {
  description = "Admin email for notifications"
  type        = string
  default     = "admin@qazaqair.kz"
}

# =============================================================================
# GRAFANA SETTINGS
# =============================================================================

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = "admin"
}

# =============================================================================
# NAGIOS SETTINGS
# =============================================================================

variable "nagios_admin_user" {
  description = "Nagios admin username"
  type        = string
  default     = "nagiosadmin"
}

variable "nagios_admin_password" {
  description = "Nagios admin password"
  type        = string
  sensitive   = true
  default     = "nagiosadmin"
}

# =============================================================================
# RESOURCE LIMITS
# =============================================================================

variable "resources_limits" {
  description = "Resource limits for containers"
  type = map(object({
    memory = string
    cpus   = string
  }))
  default = {
    db = {
      memory = "1G"
      cpus   = "0.5"
    }
    backend = {
      memory = "512M"
      cpus   = "0.5"
    }
    frontend = {
      memory = "256M"
      cpus   = "0.25"
    }
    jenkins = {
      memory = "1G"
      cpus   = "0.75"
    }
    prometheus = {
      memory = "512M"
      cpus   = "0.5"
    }
    grafana = {
      memory = "256M"
      cpus   = "0.25"
    }
    zabbix_server = {
      memory = "512M"
      cpus   = "0.5"
    }
    zabbix_web = {
      memory = "256M"
      cpus   = "0.25"
    }
    n8n = {
      memory = "512M"
      cpus   = "0.5"
    }
    nagios = {
      memory = "512M"
      cpus   = "0.5"
    }
    nginx = {
      memory = "128M"
      cpus   = "0.25"
    }
  }
}

# =============================================================================
# BACKUP SETTINGS
# =============================================================================

variable "backup_retention_days" {
  description = "Number of days to keep backups"
  type        = number
  default     = 30
}

variable "backup_schedule" {
  description = "Cron schedule for backups"
  type        = string
  default     = "0 2 * * *"  # 2 AM daily
}
