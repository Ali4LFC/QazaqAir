# Lab 3: Переменные (Variables), Locals и Outputs
# Цель: Уход от "хардкода" (жестко прописанных значений)

# =============================================================================
# LOCALS - Внутренние переменные для вычислений
# =============================================================================

locals {
  # Вычисляем общие теги на основе переменных
  common_tags = {
    Project     = "QazaqAir-Lab3"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = "lab3-variables"
  }

  # Вычисляем имя инстанса на основе окружения
  instance_name = "lab3-${var.environment}-instance"

  # Выбираем AMI на основе региона (eu-central-1)
  ami_id = "ami-0d1ddd83282187d18"  # Ubuntu 22.04 LTS для eu-central-1
}

# =============================================================================
# РЕСУРСЫ
# =============================================================================

# Security Group с динамическими правилами
resource "aws_security_group" "lab3_sg" {
  name        = "lab3-${var.environment}-sg"
  description = "Security Group для Lab 3 - ${var.environment}"

  dynamic "ingress" {
    for_each = var.allowed_ports[var.environment]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# EC2 инстансы с использованием count
resource "aws_instance" "web" {
  count = var.instance_count[var.environment]

  ami                    = local.ami_id
  instance_type          = var.instance_type[var.environment]
  vpc_security_group_ids = [aws_security_group.lab3_sg.id]

  monitoring = var.enable_monitoring[var.environment]

  tags = merge(local.common_tags, {
    Name = "${local.instance_name}-${count.index + 1}"
    Index = count.index + 1
  })
}
