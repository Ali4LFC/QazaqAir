# Lab Complete: Все 6 лаб в одной инфраструктуре
# Сценарий: Jenkins в Docker разворачивает приложение на EC2 в защищенной VPC

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
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Lab 2/3/4/5/6: AWS Provider (eu-central-1 Frankfurt)
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.common_tags
  }
}

# Lab 1: Docker Provider (для Jenkins)
# For Linux/Mac: unix:///var/run/docker.sock
# For Windows: npipe:////.//pipe//docker_engine
provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

provider "local" {}
provider "tls" {}
