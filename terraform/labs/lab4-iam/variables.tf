# Lab 4: Variables

variable "aws_region" {
  description = "AWS регион"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "users" {
  description = "Список пользователей для создания"
  type        = list(string)
  default     = ["developer1", "developer2", "analyst1"]
}

variable "environment" {
  description = "Окружение"
  type        = string
  default     = "lab4"
}
