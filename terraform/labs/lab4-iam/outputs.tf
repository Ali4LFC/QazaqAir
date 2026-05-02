# Lab 4: Outputs

output "created_users" {
  description = "Список созданных пользователей"
  value       = aws_iam_user.users[*].name
}

output "user_arns" {
  description = "ARNs созданных пользователей"
  value       = aws_iam_user.users[*].arn
}

output "created_groups" {
  description = "Список созданных групп"
  value = [
    aws_iam_group.developers.name,
    aws_iam_group.analysts.name,
    aws_iam_group.admins.name,
  ]
}

output "custom_policies" {
  description = "Созданные кастомные политики"
  value = {
    developer = aws_iam_policy.developer_policy.arn
    analyst   = aws_iam_policy.analyst_policy.arn
  }
}

output "group_memberships" {
  description = "Членство пользователей в группах"
  value = {
    developers = [for i in range(min(2, length(var.users))) : aws_iam_user.users[i].name]
    analysts   = length(var.users) >= 3 ? [aws_iam_user.users[2].name] : []
  }
}
