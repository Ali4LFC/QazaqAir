# Lab 6: Outputs

# Account Information
output "account_id" {
  description = "ID текущего AWS аккаунта (из data source)"
  value       = data.aws_caller_identity.current.account_id
}

output "current_region" {
  description = "Текущий AWS регион (из data source)"
  value       = data.aws_region.current.name
}

# AMI Information
output "amazon_linux_ami" {
  description = "Информация о Amazon Linux AMI (из data source)"
  value = {
    id        = data.aws_ami.amazon_linux.id
    name      = data.aws_ami.amazon_linux.name
    owner     = data.aws_ami.amazon_linux.owner_id
    created_at = data.aws_ami.amazon_linux.creation_date
  }
}

output "ubuntu_ami" {
  description = "Информация о Ubuntu AMI (из data source)"
  value = {
    id         = data.aws_ami.ubuntu.id
    name       = data.aws_ami.ubuntu.name
    owner      = data.aws_ami.ubuntu.owner_id
    created_at = data.aws_ami.ubuntu.creation_date
  }
}

# Availability Zones
output "available_azs" {
  description = "Доступные Availability Zones (из data source)"
  value       = data.aws_availability_zones.available.names
}

output "az_count" {
  description = "Количество доступных AZ"
  value       = length(data.aws_availability_zones.available.names)
}

# Existing Infrastructure from Lab 5
output "existing_vpcs" {
  description = "VPCs найденные по тегу Lab=lab5-vpc (из data source)"
  value       = data.aws_vpcs.lab5_vpcs.ids
}

output "public_subnets_from_lab5" {
  description = "Публичные подсети из Lab 5 (из data source)"
  value       = data.aws_subnets.lab5_public.ids
}

output "private_subnets_from_lab5" {
  description = "Приватные подсети из Lab 5 (из data source)"
  value       = data.aws_subnets.lab5_private.ids
}

output "security_group_web_id" {
  description = "ID Security Group web (из data source)"
  value       = data.aws_security_group.web.id
}

output "existing_ec2_instances" {
  description = "Существующие EC2 инстансы из Lab 5 (из data source)"
  value = {
    ids         = data.aws_instances.lab5_web.ids
    count       = length(data.aws_instances.lab5_web.ids)
    private_ips = data.aws_instances.lab5_web.private_ips
    public_ips  = data.aws_instances.lab5_web.public_ips
  }
}

# AWS Managed Policy
output "read_only_policy_arn" {
  description = "ARN политики ReadOnlyAccess (из data source)"
  value       = data.aws_iam_policy.read_only.arn
}

# New resources created based on data
output "new_instance_id" {
  description = "ID созданного инстанса на основе данных из data sources"
  value       = length(aws_instance.new_server) > 0 ? aws_instance.new_server[0].id : null
}

output "new_instance_details" {
  description = "Детали нового инстанса созданного на основе data sources"
  value = length(aws_instance.new_server) > 0 ? {
    id          = aws_instance.new_server[0].id
    public_ip   = aws_instance.new_server[0].public_ip
    private_ip  = aws_instance.new_server[0].private_ip
    ami_used    = aws_instance.new_server[0].ami
    subnet_id   = aws_instance.new_server[0].subnet_id
  } : null
}

output "infrastructure_report_file" {
  description = "Путь к сгенерированному отчету"
  value       = local_file.infrastructure_report.filename
}

# Summary
output "data_sources_summary" {
  description = "Сводка по всем использованным data sources"
  value = {
    caller_identity        = "aws_caller_identity.current - информация об аккаунте"
    region                 = "aws_region.current - информация о регионе"
    availability_zones     = "aws_availability_zones.available - список AZ"
    ami_amazon_linux       = "aws_ami.amazon_linux - AMI Amazon Linux"
    ami_ubuntu             = "aws_ami.ubuntu - AMI Ubuntu"
    vpcs                   = "aws_vpcs.lab5_vpcs - поиск VPC по тегу"
    subnets_public         = "aws_subnets.lab5_public - публичные подсети"
    subnets_private        = "aws_subnets.lab5_private - приватные подсети"
    security_group         = "aws_security_group.web - поиск security group"
    iam_policy             = "aws_iam_policy.read_only - AWS managed policy"
    instances              = "aws_instances.lab5_web - поиск EC2 инстансов"
  }
}
