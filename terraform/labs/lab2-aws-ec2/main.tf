# Lab 2: Базовый инстанс AWS
# Цель: Знакомство с облачным провайдером AWS

# Создание простейшей виртуальной машины (EC2) на Ubuntu
resource "aws_instance" "basic" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = var.instance_name
    Lab         = "lab2"
    Environment = "learning"
    ManagedBy   = "terraform"
  }
}
