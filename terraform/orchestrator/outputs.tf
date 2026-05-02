# Orchestrator Outputs

output "selected_lab" {
  description = "Выбранная лабораторная работа"
  value       = var.selected_lab == 0 ? "All Labs (1-6)" : local.labs[tostring(var.selected_lab)].name
}

output "action" {
  description = "Выбранное действие"
  value       = var.action
}

output "lab1_outputs" {
  description = "Outputs от Lab 1 (если выбрана)"
  value       = length(module.lab1) > 0 ? module.lab1[0] : null
}

output "lab2_outputs" {
  description = "Outputs от Lab 2 (если выбрана)"
  value       = length(module.lab2) > 0 ? module.lab2[0] : null
}

output "lab3_outputs" {
  description = "Outputs от Lab 3 (если выбрана)"
  value       = length(module.lab3) > 0 ? module.lab3[0] : null
}

output "lab4_outputs" {
  description = "Outputs от Lab 4 (если выбрана)"
  value       = length(module.lab4) > 0 ? module.lab4[0] : null
}

output "lab5_outputs" {
  description = "Outputs от Lab 5 (если выбрана)"
  value       = length(module.lab5) > 0 ? module.lab5[0] : null
}

output "lab6_outputs" {
  description = "Outputs от Lab 6 (если выбрана)"
  value       = length(module.lab6) > 0 ? module.lab6[0] : null
}

output "available_labs" {
  description = "Список доступных лабораторных работ"
  value       = local.labs
}

output "next_steps" {
  description = "Рекомендации по следующим шагам"
  value       = "Для уничтожения ресурсов: terraform destroy -var='selected_lab=${var.selected_lab}'"
}
