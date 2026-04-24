# Terraform Outputs for QazaqAir Infrastructure
# Module 9: IaC - Infrastructure as Code

# =============================================================================
# NETWORK OUTPUTS
# =============================================================================

output "network_name" {
  description = "Docker network name"
  value       = docker_network.app_network.name
}

output "network_subnet" {
  description = "Docker network subnet"
  value       = var.network_subnet
}

output "network_gateway" {
  description = "Docker network gateway"
  value       = var.network_gateway
}

# =============================================================================
# VOLUME OUTPUTS
# =============================================================================

output "volumes" {
  description = "List of created Docker volumes"
  value = {
    postgres_data     = docker_volume.postgres_data.name
    n8n_data          = docker_volume.n8n_data.name
    prometheus_data   = docker_volume.prometheus_data.name
    grafana_data      = docker_volume.grafana_data.name
    alertmanager_data = docker_volume.alertmanager_data.name
    jenkins_data      = docker_volume.jenkins_data.name
    portainer_data    = docker_volume.portainer_data.name
    nagios_etc        = docker_volume.nagios_etc.name
    nagios_var        = docker_volume.nagios_var.name
  }
}

# =============================================================================
# SERVICE URLS
# =============================================================================

output "service_urls" {
  description = "URLs for accessing services"
  value = {
    main_app = {
      url         = "http://${var.domain_name}:80"
      description = "Main QazaqAir Application"
    }
    backend_api = {
      url         = "http://${var.domain_name}:8000"
      description = "Backend API (FastAPI)"
    }
    frontend = {
      url         = "http://${var.domain_name}:3001"
      description = "Frontend React Application"
    }
    grafana = {
      url         = "http://${var.domain_name}:3000"
      description = "Grafana Dashboards"
      credentials = "admin / ${var.grafana_admin_password}"
    }
    prometheus = {
      url         = "http://${var.domain_name}:9090"
      description = "Prometheus Monitoring"
    }
    zabbix = {
      url         = "http://${var.domain_name}:8086"
      description = "Zabbix Monitoring"
      credentials = "Admin / zabbix"
    }
    nagios = {
      url         = "http://${var.domain_name}:8083"
      description = "Nagios Monitoring"
      credentials = "${var.nagios_admin_user} / ${var.nagios_admin_password}"
    }
    n8n = {
      url         = "http://${var.domain_name}:5678"
      description = "n8n Workflow Automation"
    }
    jenkins = {
      url         = "http://${var.domain_name}:8085"
      description = "Jenkins CI/CD"
    }
    portainer = {
      url         = "http://${var.domain_name}:9000"
      description = "Portainer Docker Management"
    }
    cadvisor = {
      url         = "http://${var.domain_name}:8080"
      description = "cAdvisor Container Metrics"
    }
    alertmanager = {
      url         = "http://${var.domain_name}:9093"
      description = "Alertmanager"
    }
  }
}

# =============================================================================
# EXPORTER ENDPOINTS
# =============================================================================

output "exporter_endpoints" {
  description = "Prometheus exporter endpoints"
  value = {
    node_exporter = {
      endpoint = "${var.domain_name}:9100"
      path     = "/metrics"
    }
    blackbox_exporter = {
      endpoint = "${var.domain_name}:9115"
      path     = "/probe"
    }
    cadvisor = {
      endpoint = "${var.domain_name}:8080"
      path     = "/metrics"
    }
  }
}

# =============================================================================
# CONTAINER INFORMATION
# =============================================================================

output "containers" {
  description = "List of deployed containers"
  value = {
    db = {
      name = docker_container.db.name
      ip   = docker_container.db.network_data[0].ip_address
    }
    backend = {
      name = docker_container.backend.name
      ip   = docker_container.backend.network_data[0].ip_address
    }
    frontend = {
      name = docker_container.frontend.name
      ip   = docker_container.frontend.network_data[0].ip_address
    }
    nginx = {
      name = docker_container.nginx.name
      ip   = docker_container.nginx.network_data[0].ip_address
    }
    prometheus = {
      name = docker_container.prometheus.name
      ip   = docker_container.prometheus.network_data[0].ip_address
    }
    grafana = {
      name = docker_container.grafana.name
      ip   = docker_container.grafana.network_data[0].ip_address
    }
    zabbix_server = {
      name = docker_container.zabbix_server.name
      ip   = docker_container.zabbix_server.network_data[0].ip_address
    }
    n8n = {
      name = docker_container.n8n.name
      ip   = docker_container.n8n.network_data[0].ip_address
    }
    jenkins = {
      name = docker_container.jenkins.name
      ip   = docker_container.jenkins.network_data[0].ip_address
    }
  }
}

# =============================================================================
# SECURITY INFORMATION
# =============================================================================

output "security_info" {
  description = "Security configuration summary"
  value = {
    ssh_port     = var.ssh_port
    ssl_enabled  = var.enable_ssl
    network_subnet = var.network_subnet
    firewall_ports = [80, 443, var.ssh_port, 8000, 3000, 3001, 5432, 5678, 8085, 8086, 8083, 9090, 9093, 9000]
  }
}

# =============================================================================
# DEPLOYMENT SUMMARY
# =============================================================================

output "deployment_summary" {
  description = "Infrastructure deployment summary"
  value = <<SUMMARY

=============================================================================
QAZAQAIR INFRASTRUCTURE DEPLOYMENT COMPLETE
=============================================================================

Project: ${var.project_name}
Environment: ${var.environment}
Domain: ${var.domain_name}

SERVICES DEPLOYED:
-----------------------------------------------------------------------------
- Database (PostgreSQL): Port 5432
- Backend API (FastAPI): Port 8000
- Frontend (React): Port 3001
- Web Server (Nginx): Ports 80/443

MONITORING STACK:
-----------------------------------------------------------------------------
- Prometheus: http://${var.domain_name}:9090
- Grafana: http://${var.domain_name}:3000 (admin/${var.grafana_admin_password})
- Zabbix: http://${var.domain_name}:8086 (Admin/zabbix)
- Nagios: http://${var.domain_name}:8083 (${var.nagios_admin_user}/${var.nagios_admin_password})
- cAdvisor: http://${var.domain_name}:8080

AUTOMATION STACK:
-----------------------------------------------------------------------------
- n8n: http://${var.domain_name}:5678
- Jenkins: http://${var.domain_name}:8085
- Portainer: http://${var.domain_name}:9000

SECURITY:
-----------------------------------------------------------------------------
- SSH Port: ${var.ssh_port}
- SSL Enabled: ${var.enable_ssl ? "Yes" : "No"}
- Network: ${var.network_subnet}

NEXT STEPS:
-----------------------------------------------------------------------------
1. Configure SSL certificates: terraform apply -var='enable_ssl=true' -var='domain_name=your-domain.com'
2. Change default passwords in all services
3. Configure Grafana dashboards
4. Setup Zabbix hosts and alerts
5. Configure n8n workflows
6. Review Jenkins pipelines

=============================================================================
SUMMARY
}

# =============================================================================
# TERRAFORM STATE INFO
# =============================================================================

output "terraform_workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}

output "terraform_version" {
  description = "Terraform version used"
  value       = "1.5.0+"
}
