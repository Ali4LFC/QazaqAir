# Orchestrator Provider Configuration

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "aws" {
  region = "eu-central-1"  # Frankfurt
  default_tags {
    tags = {
      Project   = "QazaqAir"
      ManagedBy = "Terraform"
    }
  }
}

provider "local" {}
