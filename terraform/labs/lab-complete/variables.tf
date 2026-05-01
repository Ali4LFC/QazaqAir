# Lab Complete: Variables (Lab 3 - гибкая конфигурация)
# Объединяет переменные из всех лаб

# =============================================================================
# Lab 2/3/5/6: AWS Настройки
# =============================================================================

variable "aws_region" {
  description = "AWS регион для развертывания (Lab 2)"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "environment" {
  description = "Окружение: dev, staging, prod (Lab 3)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Окружение должно быть dev, staging или prod."
  }
}

# =============================================================================
# Lab 1: Docker Настройки
# =============================================================================

variable "docker_host" {
  description = "Docker daemon connection string (Lab 1)"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "jenkins_external_port" {
  description = "Внешний порт Jenkins (Lab 1)"
  type        = number
  default     = 8080
}

variable "jenkins_admin_password" {
  description = "Пароль администратора Jenkins (Lab 1)"
  type        = string
  sensitive   = true
  default     = "admin123"
}

# =============================================================================
# Lab 2/3: EC2 Настройки
# =============================================================================

variable "instance_types" {
  description = "Типы инстансов по окружениям (Lab 3 - map переменная)"
  type        = map(string)
  default = {
    dev     = "t3.micro"    # Free Tier eligible
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

variable "instance_count" {
  description = "Количество EC2 инстансов (Lab 3)"
  type        = map(number)
  default = {
    dev     = 1
    staging = 2
    prod    = 3
  }
}

# =============================================================================
# Lab 5: Сетевые настройки VPC
# =============================================================================

variable "vpc_cidr" {
  description = "CIDR блок для VPC (Lab 5)"
  type        = string
  default     = "10.0.0.0/16"  # Как в вашей инфраструктуре
}

variable "availability_zones" {
  description = "Список Availability Zones (Lab 5)"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]  # Frankfurt AZs
}

# Lab 5: Dynamic block для Security Group
variable "security_group_rules" {
  description = "Правила Security Group (Lab 5 - Dynamic Block)"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access for application"
    },
    {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    },
    {
      port        = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Jenkins agent port (inside VPC)"
    }
  ]
}

# =============================================================================
# Lab 4: IAM Настройки
# =============================================================================

variable "iam_users" {
  description = "Список IAM пользователей для создания (Lab 4 - count)"
  type        = list(string)
  default     = ["jenkins-deployer", "developer", "viewer"]
}
