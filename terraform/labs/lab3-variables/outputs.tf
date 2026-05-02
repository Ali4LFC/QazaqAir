# Lab 3: Outputs
# Вывод данных после завершения работы

output "environment" {
  description = "Текущее окружение"
  value       = var.environment
}

output "instance_type_used" {
  description = "Использованный тип инстанса"
  value       = var.instance_type[var.environment]
}

output "instance_count" {
  description = "Количество созданных инстансов"
  value       = var.instance_count[var.environment]
}

output "instance_ids" {
  description = "IDs всех созданных инстансов"
  value       = aws_instance.web[*].id
}

output "instance_public_ips" {
  description = "Публичные IP адреса всех инстансов"
  value       = aws_instance.web[*].public_ip
}

output "security_group_id" {
  description = "ID Security Group"
  value       = aws_security_group.lab3_sg.id
}

output "security_group_name" {
  description = "Имя Security Group"
  value       = aws_security_group.lab3_sg.name
}

output "common_tags_applied" {
  description = "Примененные общие теги"
  value       = local.common_tags
}

output "all_instance_details" {
  description = "Полная информация обо всех инстансах"
  value = [
    for i, instance in aws_instance.web : {
      index      = i + 1
      id         = instance.id
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      name       = instance.tags["Name"]
    }
  ]
}
