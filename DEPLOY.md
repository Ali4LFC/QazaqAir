# Инструкция по развертыванию QazaqAir

## ⚠️ ВАЖНО: Действия перед первым запуском

### 1. Настройка переменных (Обязательно)

Откройте файл `terraform/terraform.tfvars` и измените значения:

```hcl
# Обязательно поменяйте пароли!
db_password       = "your-secure-password"
zabbix_db_password = "your-zabbix-password"
grafana_admin_password = "your-grafana-password"
nagios_admin_password = "your-nagios-password"

# Для production укажите реальный домен
domain_name = "your-domain.com"
enable_ssl  = true
```

### 2. Для Windows пользователей

**PowerShell** (запускать от Администратора):
```powershell
# Запуск без скрипта - напрямую через Terraform
cd terraform
terraform init
terraform plan
terraform apply

# Или через Docker Compose
cd ..
docker-compose up -d --build
```

### 3. Для Linux/Mac пользователей

```bash
# Сделать скрипт исполняемым
chmod +x deploy.sh

# Запуск
./deploy.sh production all
```

## 🚀 Быстрый старт

### Вариант 1: Только Docker Compose (Проще)

```bash
docker-compose up -d --build
```

### Вариант 2: Через Terraform (IaC)

```bash
cd terraform
terraform init
terraform apply
```

### Вариант 3: Полное развертывание (Ansible + Terraform + Docker)

```bash
# Требуется Linux сервер
./deploy.sh production all
```

## 📋 Проверка работы

После развертывания проверьте сервисы:

| Сервис | URL |
|--------|-----|
| Main App | http://localhost |
| Backend | http://localhost:8000 |
| Frontend | http://localhost:3001 |
| Grafana | http://localhost:3000 (admin/admin) |
| Prometheus | http://localhost:9090 |

## 🔧 Устранение проблем

### Проблема: "PasswordAuthentication no" в SSH

В `ansible/security.yml` измените:
```yaml
PasswordAuthentication: yes  # Для первой настройки
```

После настройки ключей верните `no`.

### Проблема: Docker volumes не создаются

```bash
docker volume prune  # Очистить старые
docker-compose up -d  # Пересоздать
```

### Проблема: Terraform ошибки путей

Terraform для Windows использует `//` вместо `/`. Пути уже настроены правильно.

## 📞 Поддержка

Смотрите `infrastructure/README.md` для полной документации.
