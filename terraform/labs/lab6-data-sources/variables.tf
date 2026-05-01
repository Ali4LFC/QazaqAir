# Lab 6: Variables

variable "aws_region" {
  description = "AWS регион"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "instance_type" {
  description = "Тип EC2 инстанса для создания"
  type        = string
  default     = "t3.micro"  # Free Tier eligible
}

variable "environment" {
  description = "Окружение для фильтрации data sources"
  type        = string
  default     = "lab5"  # Предполагается что Lab 5 была запущена
}
