# Lab Complete: Значения переменных по умолчанию
# Настроено под eu-central-1 (Frankfurt) и ваши параметры

environment = "dev"
aws_region  = "eu-central-1"  # Frankfurt

# Jenkins настройки
jenkins_external_port = 8080

# Можно указать конкретный AMI (например ami-0d1ddd83282187d18)
# или оставить пустым для автоматического поиска через data source
custom_ami_id = "ami-0d1ddd83282187d18"  # Ubuntu 22.04 LTS eu-central-1

# Для продакшена используйте terraform.tfvars.prod
