# Terraform Variables for QazaqAir
# Copy this file and customize values for your environment

# =============================================================================
# PROJECT SETTINGS
# =============================================================================

project_name = "qazaqair"
environment  = "production"

# =============================================================================
# DOMAIN AND SSL
# =============================================================================

domain_name = "localhost"
admin_email = "admin@qazaqair.kz"
enable_ssl  = false

# =============================================================================
# SECURITY SETTINGS
# =============================================================================

ssh_port = 2222

# =============================================================================
# DATABASE CREDENTIALS
# =============================================================================

db_password       = "password"
zabbix_db_password = "zabbix_password"

# =============================================================================
# SERVICE PASSWORDS
# =============================================================================

grafana_admin_password = "admin"
nagios_admin_user     = "nagiosadmin"
nagios_admin_password = "nagiosadmin"

# =============================================================================
# BACKUP SETTINGS
# =============================================================================

backup_retention_days = 30
backup_schedule       = "0 2 * * *"
