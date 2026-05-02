# Lab 5: Сетевая инфраструктура (VPC) и Dynamic Blocks
# Цель: Создание полноценной защищенной сети
# Отличие: Глубокая настройка сети и использование продвинутых конструкций Terraform

# =============================================================================
# LOCALS
# =============================================================================

locals {
  common_tags = {
    Lab       = "lab5-vpc"
    ManagedBy = "Terraform"
  }

  # Количество AZ для создания
  az_count = min(length(var.availability_zones), length(var.public_subnet_cidrs))
}

# =============================================================================
# VPC
# =============================================================================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "lab5-vpc"
  })
}

# =============================================================================
# INTERNET GATEWAY
# =============================================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "lab5-igw"
  })
}

# =============================================================================
# SUBNETS (с использованием for_each для гибкости)
# =============================================================================

# Публичные подсети
resource "aws_subnet" "public" {
  count = local.az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "lab5-public-subnet-${count.index + 1}"
    Type = "public"
  })
}

# Приватные подсети
resource "aws_subnet" "private" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "lab5-private-subnet-${count.index + 1}"
    Type = "private"
  })
}

# =============================================================================
# ELASTIC IPs для NAT Gateway
# =============================================================================

resource "aws_eip" "nat" {
  count = local.az_count

  vpc = true

  tags = merge(local.common_tags, {
    Name = "lab5-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.main]
}

# =============================================================================
# NAT GATEWAYS
# =============================================================================

resource "aws_nat_gateway" "main" {
  count = local.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(local.common_tags, {
    Name = "lab5-nat-gateway-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.main]
}

# =============================================================================
# ROUTE TABLES
# =============================================================================

# Публичная Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "lab5-public-rt"
  })
}

# Приватные Route Tables (по одной на каждую AZ)
resource "aws_route_table" "private" {
  count = local.az_count

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(local.common_tags, {
    Name = "lab5-private-rt-${count.index + 1}"
  })
}

# Ассоциации Route Table с подсетями
resource "aws_route_table_association" "public" {
  count = local.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = local.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# =============================================================================
# SECURITY GROUPS с DYNAMIC BLOCKS
# =============================================================================

resource "aws_security_group" "web" {
  name        = "lab5-web-sg"
  description = "Security Group для web серверов с dynamic ingress rules"
  vpc_id      = aws_vpc.main.id

  # DYNAMIC BLOCK для ingress правил
  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  # Разрешить весь исходящий трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "lab5-web-sg"
  })
}

# Дополнительный Security Group для базы данных
resource "aws_security_group" "database" {
  name        = "lab5-database-sg"
  description = "Security Group для базы данных"
  vpc_id      = aws_vpc.main.id

  # Доступ к БД только из VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "PostgreSQL доступ из VPC"
  }

  # Разрешить весь исходящий трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "lab5-database-sg"
  })
}

# =============================================================================
# EC2 ИНСТАНСЫ ДЛЯ ДЕМОНСТРАЦИИ
# =============================================================================

resource "aws_instance" "web" {
  count = min(2, local.az_count)

  ami                    = "ami-0d1ddd83282187d18"  # Ubuntu 22.04 LTS eu-central-1
  instance_type          = "t3.micro"  # Free Tier eligible
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Lab 5 VPC Demo - Server ${count.index + 1}</h1>" > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = merge(local.common_tags, {
    Name = "lab5-web-server-${count.index + 1}"
  })
}
