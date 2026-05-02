# Lab Complete: Outputs (Lab 3)
# Вывод информации обо всех созданных ресурсах

# =============================================================================
# Lab 6: Data Sources Outputs
# =============================================================================

output "data_sources_info" {
  description = "Информация из Data Sources (Lab 6)"
  value = {
    account_id      = data.aws_caller_identity.current.account_id
    region          = data.aws_region.current.name
    available_azs   = data.aws_availability_zones.available.names
    ubuntu_ami_id   = data.aws_ami.ubuntu.id
    ubuntu_ami_name = data.aws_ami.ubuntu.name
  }
}

# =============================================================================
# Lab 5: VPC Outputs
# =============================================================================

output "vpc_info" {
  description = "Информация о VPC (Lab 5)"
  value = {
    vpc_id              = aws_vpc.main.id
    vpc_cidr            = aws_vpc.main.cidr_block
    internet_gateway_id = aws_internet_gateway.main.id
    nat_gateway_id      = aws_nat_gateway.main.id
    nat_gateway_eip     = aws_eip.nat.public_ip
  }
}

output "subnets_info" {
  description = "Информация о подсетях (Lab 5)"
  value = {
    public_subnet_ids  = aws_subnet.public[*].id
    public_subnet_cidrs = aws_subnet.public[*].cidr_block
    private_subnet_ids = aws_subnet.private[*].id
    private_subnet_cidrs = aws_subnet.private[*].cidr_block
  }
}

output "security_groups_info" {
  description = "Security Groups (Lab 5 Dynamic Block)"
  value = {
    app_sg_id    = aws_security_group.app.id
    jenkins_sg_id = aws_security_group.jenkins.id
    app_sg_rules = [
      for rule in var.security_group_rules : {
        port        = rule.port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
        description = rule.description
      }
    ]
  }
}

# =============================================================================
# Lab 4: IAM Outputs
# =============================================================================

output "iam_info" {
  description = "IAM ресурсы (Lab 4)"
  value = {
    role_name       = aws_iam_role.ec2_role.name
    role_arn        = aws_iam_role.ec2_role.arn
    instance_profile = aws_iam_instance_profile.ec2_profile.name
    policy_arn      = aws_iam_policy.app_policy.arn
    users           = aws_iam_user.users[*].name
    developers_group = aws_iam_group.developers.name
  }
}

# =============================================================================
# Lab 2/3: EC2 Outputs
# =============================================================================

output "ec2_instances" {
  description = "EC2 инстансы (Lab 2 + Lab 3)"
  value = {
    count           = length(aws_instance.app)
    instance_type   = local.current_instance_type
    instances = [
      for i, instance in aws_instance.app : {
        index      = i + 1
        id         = instance.id
        private_ip = instance.private_ip
        subnet     = instance.subnet_id
        az         = instance.availability_zone
      }
    ]
  }
}

output "bastion_server" {
  description = "Bastion хост для доступа к приватным инстансам"
  value = {
    id         = aws_instance.bastion.id
    public_ip  = aws_instance.bastion.public_ip
    private_ip = aws_instance.bastion.private_ip
  }
}

output "ssh_commands" {
  description = "SSH команды для подключения"
  value = <<EOF

================================================================================
                         SSH ACCESS COMMANDS
================================================================================

KEY FILE LOCATION:
  ${local_file.private_key.filename}

BASTION SSH (run from: terraform/labs/lab-complete):
  ssh -i dev-private-key.pem ubuntu@${aws_instance.bastion.public_ip}

OR from project root:
  ssh -i terraform/labs/lab-complete/dev-private-key.pem ubuntu@${aws_instance.bastion.public_ip}

PRIVATE EC2 VIA BASTION:
  ssh -i dev-private-key.pem -J ubuntu@${aws_instance.bastion.public_ip} ubuntu@${aws_instance.app[0].private_ip}

POWERSHELL (Windows):
  ssh -i .\dev-private-key.pem ubuntu@${aws_instance.bastion.public_ip}

================================================================================
EOF
}

output "ssh_key" {
  description = "SSH ключ для доступа к инстансам"
  value = {
    key_name    = aws_key_pair.main.key_name
    private_key_file = local_file.private_key.filename
  }
  sensitive = true
}

# =============================================================================
# Lab 1: Docker/Jenkins Outputs
# =============================================================================

output "jenkins_info" {
  description = "Jenkins контейнер (Lab 1 Docker)"
  value = {
    container_name = docker_container.jenkins.name
    container_id   = docker_container.jenkins.id
    url            = "http://localhost:${var.jenkins_external_port}"
    network        = docker_network.jenkins.name
    volume         = docker_volume.jenkins_data.name
  }
}

# =============================================================================
# S3 Bucket
# =============================================================================

output "s3_bucket" {
  description = "S3 бакет для артефактов"
  value = {
    bucket_name = aws_s3_bucket.artifacts.bucket
    bucket_arn  = aws_s3_bucket.artifacts.arn
  }
}

# =============================================================================
# Lab 3: Variables Summary
# =============================================================================

output "configuration_summary" {
  description = "Сводка конфигурации (Lab 3 Variables)"
  value = {
    environment       = var.environment
    aws_region        = var.aws_region
    instance_type     = local.current_instance_type
    instance_count    = local.current_instance_count
    vpc_cidr          = var.vpc_cidr
    docker_host       = var.docker_host
    jenkins_port      = var.jenkins_external_port
  }
}

# =============================================================================
# Как все работает вместе
# =============================================================================

output "lab_integration_guide" {
  description = "Как лабы работают вместе"
  value = <<-EOT

    ═══════════════════════════════════════════════════════════
       КАК ВСЕ 6 ЛАБ РАБОТАЮТ ВМЕСТЕ
    ═══════════════════════════════════════════════════════════

    Lab 6 (Data Sources):
      → Получаем AMI Ubuntu и информацию о регионе
      → Используется для создания EC2 инстансов

    Lab 5 (VPC + Dynamic Blocks):
      → Создаем изолированную сеть (VPC)
      → Публичная подсеть для Bastion
      → Приватные подсети для приложений
      → Security Groups с динамическими правилами

    Lab 4 (IAM):
      → Роли и политики для EC2
      → Пользователи и группы для команды
      → EC2 имеет доступ к S3

    Lab 2 (EC2):
      → Приватные серверы приложений
      → Публичный Bastion для SSH доступа
      → Подключаются к VPC Lab 5

    Lab 1 (Docker + Jenkins):
      → Jenkins работает локально в Docker
      → Может деплоить на EC2 через SSH
      → Хранит артефакты в S3

    Lab 3 (Variables):
      → Все параметры в variables.tf
      → Гибкая конфигурация через окружения
      → Outputs для всей информации

    ═══════════════════════════════════════════════════════════
       ДОСТУП К РЕСУРСАМ
    ═══════════════════════════════════════════════════════════

    Jenkins UI:        http://localhost:${var.jenkins_external_port}
    Bastion SSH:       ssh -i ${local_file.private_key.filename} ubuntu@${aws_instance.bastion.public_ip}
    Приватные серверы: Через Bastion: ssh -J ubuntu@${aws_instance.bastion.public_ip} ubuntu@<private_ip>
    S3 Bucket:         ${aws_s3_bucket.artifacts.bucket}

    ═══════════════════════════════════════════════════════════
  EOT
}
