# Lab 1: Outputs

output "jenkins_url" {
  description = "URL доступа к Jenkins"
  value       = "http://localhost:${var.jenkins_external_port}"
}

output "jenkins_container_name" {
  description = "Имя контейнера Jenkins"
  value       = docker_container.jenkins.name
}

output "jenkins_volume_name" {
  description = "Имя тома Jenkins"
  value       = docker_volume.jenkins_data.name
}
