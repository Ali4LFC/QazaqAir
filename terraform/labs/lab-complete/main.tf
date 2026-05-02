# Lab Complete: Все 6 лаб в одной инфраструктуре
# Сценарий: Полный CI/CD pipeline с Jenkins в Docker и EC2 в VPC
#
# Как работают лабы вместе:
# - Lab 6 (Data Sources): Получаем AMI и информацию о регионе
# - Lab 5 (VPC): Создаем сеть с публичной и приватной подсетями
# - Lab 4 (IAM): Создаем роли для EC2 и пользователей
# - Lab 2 (EC2): Создаем серверы приложений в приватной подсети
# - Lab 1 (Docker): Создаем Jenkins для деплоя
# - Lab 3 (Variables): Вся конфигурация управляется переменными

# =============================================================================
# Lab 3: LOCALS (вычисляемые значения)
# =============================================================================

locals {
  # Общие теги для всех ресурсов
  common_tags = {
    Project     = "QazaqAir-Complete-Lab"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = "lab-complete"
  }

  # Вычисляемые значения на основе окружения
  current_instance_type = var.instance_types[var.environment]
  current_instance_count = var.instance_count[var.environment]

  # Имена ресурсов
  vpc_name           = "${var.environment}-vpc"
  jenkins_name       = "${var.environment}-jenkins"
  iam_role_name      = "${var.environment}-ec2-role"
}

# =============================================================================
# Lab 6: DATA SOURCES (получение существующих данных)
# =============================================================================

# Получаем информацию о текущем аккаунте
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Получаем список доступных AZ
data "aws_availability_zones" "available" {
  state = "available"
}

# Получаем Ubuntu 22.04 AMI для eu-central-1 (Lab 6 - data source)
# Или используем ваш AMI: ami-0d1ddd83282187d18
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Переменная для вашего конкретного AMI (опционально)
variable "custom_ami_id" {
  description = "Конкретный AMI ID (например ami-0d1ddd83282187d18 для eu-central-1)"
  type        = string
  default     = ""  # Пусто = использовать data source
}

# =============================================================================
# Lab 5: VPC и СЕТЕВАЯ ИНФРАСТРУКТУРА
# =============================================================================

# Создаем VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = local.vpc_name
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-igw"
  })
}

# Публичная подсеть (для bastion/nat)
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-public-${count.index + 1}"
    Type = "public"
  })
}

# Приватная подсеть (для приложений)
resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "${var.environment}-private-${count.index + 1}"
    Type = "private"
  })
}

# Elastic IP для NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-nat-eip"
  })

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway (приватные инстансы выходят в интернет через него)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(local.common_tags, {
    Name = "${var.environment}-nat"
  })

  depends_on = [aws_internet_gateway.main]
}

# Route Table для публичной подсети
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-public-rt"
  })
}

# Route Table для приватной подсети
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-private-rt"
  })
}

# Ассоциации Route Tables
resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# =============================================================================
# Lab 5: SECURITY GROUPS с DYNAMIC BLOCKS
# =============================================================================

resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security Group for applications (Lab 5 Dynamic Block)"
  vpc_id      = aws_vpc.main.id

  # Lab 5: Dynamic Block для ingress правил
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-app-sg"
  })
}

# Security Group for Jenkins (Lab 1)
resource "aws_security_group" "jenkins" {
  name        = "${var.environment}-jenkins-sg"
  description = "Security Group for Jenkins server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins Web UI"
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Jenkins Agent"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-jenkins-sg"
  })
}

# =============================================================================
# Lab 4: IAM РОЛИ и ПОЛИТИКИ
# =============================================================================

# IAM Policy Document для EC2 (Lab 4 - data source)
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Policy Document для доступа к S3
data "aws_iam_policy_document" "app_policy" {
  statement {
    sid    = "S3Access"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.environment}-app-bucket-*",
      "arn:aws:s3:::${var.environment}-app-bucket-*/*",
    ]
  }

  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

# IAM Role для EC2 инстансов
resource "aws_iam_role" "ec2_role" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.iam_role_name
  })
}

# IAM Policy для приложения
resource "aws_iam_policy" "app_policy" {
  name        = "${var.environment}-app-policy"
  description = "Policy for EC2 applications"
  policy      = data.aws_iam_policy_document.app_policy.json
  # Note: tags are inherited from provider default_tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "app_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Users (Lab 4 - с использованием count)
resource "aws_iam_user" "users" {
  count = length(var.iam_users)

  name = "${var.environment}-${var.iam_users[count.index]}"
  path = "/${var.environment}/"

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.iam_users[count.index]}"
  })
}

# Группа для разработчиков
resource "aws_iam_group" "developers" {
  name = "${var.environment}-developers"
  path = "/${var.environment}/"
}

# Добавляем пользователей в группу
resource "aws_iam_user_group_membership" "dev_membership" {
  count = length(var.iam_users)

  user   = aws_iam_user.users[count.index].name
  groups = [aws_iam_group.developers.name]
}

# =============================================================================
# Lab 2: EC2 ИНСТАНСЫ (с использованием Lab 3 Variables)
# =============================================================================

# SSH Key Pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "${var.environment}-key"
  public_key = tls_private_key.ssh.public_key_openssh
  # Note: tags are inherited from provider default_tags
}

# Сохраняем приватный ключ локально
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/${var.environment}-private-key.pem"
  file_permission = "0400"
}

# Локал для выбора AMI (custom или data source)
locals {
  ami_id = var.custom_ami_id != "" ? var.custom_ami_id : data.aws_ami.ubuntu.id
}

# EC2 инстансы (Lab 2 + Lab 3 count)
resource "aws_instance" "app" {
  count = local.current_instance_count

  ami                    = local.ami_id  # Lab 6 data source или custom AMI
  instance_type          = local.current_instance_type
  subnet_id              = aws_subnet.private[count.index % length(aws_subnet.private)].id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = aws_key_pair.main.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>QazaqAir App - ${var.environment} - Server ${count.index + 1}</h1>" > /var/www/html/index.html
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = merge(local.common_tags, {
    Name = "${var.environment}-app-${count.index + 1}"
  })
}

# Bastion host в публичной подсети (для доступа к приватным инстансам)
resource "aws_instance" "bastion" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"  # Free Tier eligible
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = aws_key_pair.main.key_name

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Bastion Server - ${var.environment}</h1>" > /var/www/html/index.html
              systemctl start nginx
              EOF

  tags = merge(local.common_tags, {
    Name = "${var.environment}-bastion"
  })
}

# =============================================================================
# Lab 1: DOCKER + JENKINS (локальный контейнер)
# =============================================================================

# Docker том для Jenkins
resource "docker_volume" "jenkins_data" {
  name = "${local.jenkins_name}-data"

  labels {
    label = "environment"
    value = var.environment
  }
}

# Docker сеть
resource "docker_network" "jenkins" {
  name = "${local.jenkins_name}-network"

  labels {
    label = "environment"
    value = var.environment
  }
}

# Jenkins контейнер
resource "docker_container" "jenkins" {
  name  = local.jenkins_name
  image = "jenkins/jenkins:lts-jdk17"

  restart = "always"
  user    = "root"

  ports {
    internal = 8080
    external = var.jenkins_external_port
  }

  ports {
    internal = 50000
    external = 50000
  }

  volumes {
    volume_name    = docker_volume.jenkins_data.name
    container_path = "/var/jenkins_home"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  # Монтируем SSH ключ для доступа к EC2
  volumes {
    host_path      = abspath(local_file.private_key.filename)
    container_path = "/var/jenkins_home/.ssh/id_rsa"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.jenkins.name
  }

  env = [
    "JAVA_OPTS=-Djenkins.install.runSetupWizard=false",
    "JENKINS_OPTS=--argumentsRealm.roles.user=admin --argumentsRealm.roles.password=${var.jenkins_admin_password}"
  ]

  labels {
    label = "lab"
    value = "lab-complete"
  }

  labels {
    label = "service"
    value = "jenkins"
  }

  labels {
    label = "environment"
    value = var.environment
  }
}

# =============================================================================
# S3 Bucket для артефактов (связь между Jenkins и EC2)
# =============================================================================

resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.environment}-app-bucket-${data.aws_caller_identity.current.account_id}"

  tags = merge(local.common_tags, {
    Name = "${var.environment}-artifacts"
  })
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
