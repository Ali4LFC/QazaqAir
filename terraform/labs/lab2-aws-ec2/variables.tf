# Lab 2: Variables

variable "aws_region" {
  description = "AWS регион для развертывания"
  type        = string
  default     = "eu-central-1"  # Frankfurt
}

variable "instance_name" {
  description = "Имя EC2 инстанса"
  type        = string
  default     = "lab2-basic-instance"
}

variable "instance_type" {
  description = "Тип EC2 инстанса"
  type        = string
  default     = "t3.micro"  # Free Tier eligible
}

variable "ami_id" {
  description = "ID Amazon Machine Image (Ubuntu 22.04 для eu-central-1)"
  type        = string
  default     = "ami-0d1ddd83282187d18"  # Ubuntu 22.04 LTS eu-central-1
}
