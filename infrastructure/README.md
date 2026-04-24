# QazaqAir Infrastructure as Code (IaC)

## Module 9: Автоматизация развертывания инфраструктуры

Этот модуль содержит полную конфигурацию Infrastructure as Code (IaC) для проекта QazaqAir, включая Terraform и Ansible.

## 📁 Структура директорий

```
.
├── terraform/                 # Terraform конфигурации
│   ├── provider.tf           # Провайдеры Docker и Local
│   ├── variables.tf            # Переменные инфраструктуры
│   ├── main.tf               # Основные ресурсы (сети, volumes, контейнеры)
│   ├── outputs.tf            # Выходные данные (URLs, endpoints)
│   └── terraform.tfvars.example # Пример переменных
│
├── ansible/                   # Ansible плейбуки
│   ├── ansible.cfg            # Конфигурация Ansible
│   ├── inventory.ini          # Инвентарь серверов
│   ├── setup.yml              # Начальная настройка сервера
│   ├── security.yml           # Настройка безопасности
│   └── monitoring.yml         # Установка мониторинга
│
├── deploy.sh                  # Скрипт развертывания
├── Jenkinsfile              # CI/CD пайплайн
└── README.md                # Этот файл
```

## 🚀 Быстрый старт

### Предварительные требования

- **Docker** и **Docker Compose**
- **Terraform** >= 1.5.0
- **Ansible** >= 2.9
- **Git**

### Установка инструментов (Ubuntu/Debian)

```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Ansible
sudo apt install ansible
```

## 🔧 Использование

### 1. Полное развертывание (рекомендуется)

```bash
# Развертывание в production
./deploy.sh production all

# Развертывание в dev
./deploy.sh dev all
```

### 2. Пошаговое развертывание

```bash
# Шаг 1: Начальная настройка сервера
./deploy.sh production setup

# Шаг 2: Настройка безопасности
./deploy.sh production security

# Шаг 3: Установка мониторинга
./deploy.sh production monitoring

# Шаг 4: Инициализация Terraform
./deploy.sh production terraform-init

# Шаг 5: Планирование изменений
./deploy.sh production terraform-plan

# Шаг 6: Применение конфигурации
./deploy.sh production terraform-apply

# Шаг 7: Сборка и деплой Docker
./deploy.sh production docker-build
./deploy.sh production docker-deploy
```

### 3. Управление инфраструктурой

```bash
# Проверка статуса
./deploy.sh production status

# Просмотр логов
./deploy.sh production logs
./deploy.sh production logs backend

# Создание бэкапа
./deploy.sh production backup

# Остановка сервисов
./deploy.sh production docker-stop

# Удаление инфраструктуры (ОСТОРОЖНО!)
./deploy.sh production terraform-destroy
```

## 🏗️ Terraform Конфигурация

### Провайдеры

- **Docker**: Управление контейнерами, сетями, volumes
- **Local**: Локальные ресурсы и файлы

### Ресурсы

#### Сети
- `qazaqair-network` - основная Docker сеть (172.20.0.0/16)

#### Volumes
- `postgres_data` - данные PostgreSQL
- `prometheus_data` - данные Prometheus
- `grafana_data` - данные Grafana
- `n8n_data` - данные n8n
- `jenkins_data` - данные Jenkins
- `alertmanager_data` - данные Alertmanager
- `portainer_data` - данные Portainer
- `nagios_etc/var` - конфигурация Nagios

#### Контейнеры
- **Core**: db, backend, frontend, nginx
- **Monitoring**: prometheus, grafana, node-exporter, cadvisor, zabbix-server, zabbix-web, zabbix-db, nagios
- **Automation**: n8n, jenkins, portainer
- **Alerting**: alertmanager, blackbox-exporter

### Переменные

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| `project_name` | Имя проекта | qazaqair |
| `environment` | Окружение | production |
| `domain_name` | Домен | localhost |
| `db_password` | Пароль БД | password |
| `grafana_admin_password` | Пароль Grafana | admin |
| `ssh_port` | SSH порт | 2222 |

### Настройка переменных

```bash
# Скопируйте пример
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

# Отредактируйте значения
vim terraform/terraform.tfvars
```

## 🔐 Ansible Плейбуки

### setup.yml
Начальная настройка сервера:
- Обновление системы
- Установка Docker и Docker Compose
- Создание пользователей и директорий
- Настройка системных сервисов

### security.yml
Настройка безопасности:
- UFW (файрвол)
- Fail2Ban (защита от брутфорса)
- SSH харднинг
- SSL/TLS сертификаты
- Kernel hardening (sysctl)
- Автоматические обновления безопасности

### monitoring.yml
Настройка мониторинга:
- Prometheus конфигурация
- Grafana dashboards
- Alertmanager правила
- Nagios настройка

## 📊 CI/CD с Jenkins

### Запуск пайплайна

```bash
# Вручную через Jenkins UI
1. Откройте Jenkins (http://localhost:8085)
2. Создайте новый Pipeline job
3. Укажите путь к Jenkinsfile
4. Запустите сборку
```

### Параметры сборки

- **ENVIRONMENT**: dev, staging, production
- **DEPLOYMENT_ACTION**: plan, apply, destroy, backup, security-scan
- **AUTO_APPROVE**: Автоматическое подтверждение
- **SKIP_TESTS**: Пропуск тестов

### Этапы пайплайна

1. **Checkout** - Получение кода
2. **Pre-build Checks** - Линтинг
3. **Build** - Сборка Docker образов
4. **Security Scan** - Сканирование уязвимостей
5. **Test** - Unit и интеграционные тесты
6. **Terraform Plan** - Планирование изменений
7. **Approval** - Ручное подтверждение
8. **Terraform Apply** - Применение конфигурации
9. **Deploy Services** - Деплой сервисов
10. **Smoke Tests** - Проверка работоспособности

## 🔗 Интеграция сервисов

### После развертывания доступны:

| Сервис | URL | Учетные данные |
|--------|-----|----------------|
| Main App | http://localhost | - |
| Backend API | http://localhost:8000 | - |
| Frontend | http://localhost:3001 | - |
| Grafana | http://localhost:3000 | admin/admin |
| Prometheus | http://localhost:9090 | - |
| Zabbix | http://localhost:8086 | Admin/zabbix |
| Nagios | http://localhost:8083 | nagiosadmin/nagiosadmin |
| n8n | http://localhost:5678 | - |
| Jenkins | http://localhost:8085 | - |
| Portainer | http://localhost:9000 | - |

## 📝 Логи и мониторинг

```bash
# Просмотр логов развертывания
cat deploy.log

# Логи Terraform
cd terraform && terraform show

# Логи Ansible
ls -la ansible/logs/

# Docker логи
docker-compose logs -f [service]
```

## 🛠️ Устранение неполадок

### Проблема: Terraform не инициализируется

```bash
cd terraform
terraform init -upgrade
```

### Проблема: Ansible не подключается

```bash
# Проверка SSH
ssh -p 2222 localhost

# Проверка inventory
ansible -i ansible/inventory.ini all -m ping
```

### Проблема: Docker контейнеры не запускаются

```bash
# Проверка статуса
docker-compose ps
docker-compose logs

# Пересборка
docker-compose down
docker-compose up -d --build
```

## 📚 Документация

- [Terraform Documentation](https://www.terraform.io/docs)
- [Ansible Documentation](https://docs.ansible.com)
- [Docker Documentation](https://docs.docker.com)
- [Jenkins Documentation](https://www.jenkins.io/doc)

## 📄 Лицензия

Этот проект является частью QazaqAir. Все права защищены.

## 👥 Авторы

- Infrastructure Team - QazaqAir Project
