# Lab 3: Variables
# Цель: Сделать конфигурацию гибкой и переиспользуемой

# =============================================================================
# БАЗОВЫЕ НАСТРОЙКИ
# =============================================================================

variable "aws_region" {
  description = "AWS регион для развертывания"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "environment" {
  description = "Окружение (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Окружение должно быть dev, staging или prod."
  }
}

# =============================================================================
# НАСТРОЙКИ ИНСТАНСА
# =============================================================================

variable "instance_type" {
  description = "Тип EC2 инстанса"
  type        = map(string)
  default = {
    dev     = "t3.micro"    # Free Tier
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

variable "instance_count" {
  description = "Количество инстансов для создания"
  type        = map(number)
  default = {
    dev     = 1
    staging = 2
    prod    = 3
  }
}

variable "enable_monitoring" {
  description = "Включить detailed monitoring"
  type        = map(bool)
  default = {
    dev     = false
    staging = false
    prod    = true
  }
}

# =============================================================================
# СЕТЕВЫЕ НАСТРОЙКИ
# =============================================================================

variable "allowed_ports" {
  description = "Список открытых портов"
  type        = map(list(number))
  default = {
    dev     = [22, 80]
    staging = [22, 80, 443]
    prod    = [22, 80, 443, 8080]
  }
}
