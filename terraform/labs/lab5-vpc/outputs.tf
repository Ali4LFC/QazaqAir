# Lab 5: Outputs

output "vpc_id" {
  description = "ID созданного VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR блок VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "IDs публичных подсетей"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs приватных подсетей"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "IDs NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "Публичные IP NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "security_group_web_id" {
  description = "ID Security Group для web серверов"
  value       = aws_security_group.web.id
}

output "security_group_web_rules" {
  description = "Примененные правила Security Group (демонстрация dynamic block)"
  value = [
    for rule in var.security_group_rules : {
      port        = rule.port
      protocol    = rule.protocol
      cidr_blocks = rule.cidr_blocks
      description = rule.description
    }
  ]
}

output "web_server_public_ips" {
  description = "Публичные IP web серверов"
  value       = aws_instance.web[*].public_ip
}

output "web_server_urls" {
  description = "URLs для доступа к web серверам"
  value = [
    for ip in aws_instance.web[*].public_ip : "http://${ip}"
  ]
}

output "network_summary" {
  description = "Сводка по созданной сети"
  value = {
    vpc_id              = aws_vpc.main.id
    vpc_cidr            = aws_vpc.main.cidr_block
    public_subnets      = length(aws_subnet.public)
    private_subnets     = length(aws_subnet.private)
    nat_gateways        = length(aws_nat_gateway.main)
    web_servers         = length(aws_instance.web)
    availability_zones  = var.availability_zones
  }
}
