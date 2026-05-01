# Lab 1: Variables

variable "docker_host" {
  description = "Docker daemon connection string"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "jenkins_external_port" {
  description = "External port for Jenkins"
  type        = number
  default     = 8080
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
  default     = "admin123"
}
