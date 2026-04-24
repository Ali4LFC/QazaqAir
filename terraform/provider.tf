# Terraform Provider Configuration for QazaqAir Infrastructure
# Module 9: IaC - Infrastructure as Code

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# Docker Provider Configuration
provider "docker" {
  host = var.docker_host

  # For Windows with Docker Desktop
  # host = "npipe:////.//pipe//docker_engine"

  # For Linux/Mac
  # host = "unix:///var/run/docker.sock"
}

provider "local" {
  # Local provider for file operations
}
