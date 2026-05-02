# Lab 2: Outputs

output "instance_id" {
  description = "ID созданного EC2 инстанса"
  value       = aws_instance.basic.id
}

output "instance_public_ip" {
  description = "Публичный IP адрес инстанса"
  value       = aws_instance.basic.public_ip
}

output "instance_private_ip" {
  description = "Приватный IP адрес инстанса"
  value       = aws_instance.basic.private_ip
}

output "instance_state" {
  description = "Состояние инстанса"
  value       = aws_instance.basic.instance_state
}

output "ami_used" {
  description = "Использованный AMI ID"
  value       = aws_instance.basic.ami
}
