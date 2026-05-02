# Lab 1: Docker + Jenkins
# Цель: Управление локальными (контейнерными) ресурсами

# Создание Docker образа Jenkins
resource "docker_image" "jenkins" {
  name = "jenkins/jenkins:lts-jdk17"
}

# Создание тома для Jenkins данных
resource "docker_volume" "jenkins_data" {
  name = "lab1-jenkins-data"
}

# Запуск контейнера Jenkins
resource "docker_container" "jenkins" {
  name  = "lab1-jenkins"
  image = docker_image.jenkins.image_id

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

  env = [
    "JAVA_OPTS=-Djenkins.install.runSetupWizard=false",
    "JENKINS_OPTS=--argumentsRealm.roles.user=admin --argumentsRealm.roles.password=${var.jenkins_admin_password}"
  ]

  labels {
    label = "lab"
    value = "lab1"
  }

  labels {
    label = "service"
    value = "jenkins"
  }
}
