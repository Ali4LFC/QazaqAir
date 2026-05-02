# Lab 5: Variables

variable "aws_region" {
  description = "AWS регион"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"  # Как в вашей инфраструктуре
}

variable "availability_zones" {
  description = "Список availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]  # Frankfurt AZs
}

variable "public_subnet_cidrs" {
  description = "CIDR блоки для публичных подсетей"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]  # Как в вашей инфраструктуре: 10.0.0.0/24
}

variable "private_subnet_cidrs" {
  description = "CIDR блоки для приватных подсетей"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]  # Приватные подсети
}

# Dynamic блок для security group правил
variable "security_group_rules" {
  description = "Правила для Security Group (для dynamic block)"
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
      description = "SSH доступ"
    },
    {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP доступ"
    },
    {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS доступ"
    },
    {
      port        = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
      description = "Внутренний порт приложения"
    }
  ]
}
