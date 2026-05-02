# Terraform Labs

Эта директория содержит 6 лабораторных работ по Terraform, которые можно запускать по отдельности или все вместе.

## Структура

```
labs/
├── lab1-docker-jenkins/     # Docker + Jenkins (локальные контейнеры)
├── lab2-aws-ec2/            # Базовый инстанс AWS
├── lab3-variables/          # Variables, Locals, Outputs
├── lab4-iam/                # IAM Users, Groups, Policies
├── lab5-vpc/                # VPC и Dynamic Blocks
├── lab6-data-sources/       # Data Sources
├── lab-complete/            # ВСЕ 6 лаб в ОДНОЙ инфраструктуре
└── README.md
```

## Запуск лаб

### Windows (PowerShell)

```powershell
# Запуск конкретной лабы (например, Lab 1)
.\run-lab.ps1 -LabNumber 1 -Action apply -AutoApprove

# Планирование изменений
.\run-lab.ps1 -LabNumber 3 -Action plan

# Уничтожение ресурсов
.\run-lab.ps1 -LabNumber 2 -Action destroy -AutoApprove

# Запуск всех лаб (через orchestrator)
.\run-lab.ps1 -LabNumber 0 -Action apply

# Запуск ПОЛНОЙ лабы (все 6 лаб в одной инфраструктуре) - РЕКОМЕНДУЕТСЯ
.\run-lab.ps1 -LabNumber 7 -Action apply -AutoApprove

# Показать справку
.\run-lab.ps1 -Help
```

### Linux/Mac (Bash)

```bash
# Запуск конкретной лабы (например, Lab 1)
./run-lab.sh -l 1 -a apply -y

# Планирование изменений
./run-lab.sh -l 3 -a plan

# Уничтожение ресурсов
./run-lab.sh -l 2 -a destroy -y

# Запуск всех лаб (через orchestrator)
./run-lab.sh -l 0 -a apply

# Запуск ПОЛНОЙ лабы (все 6 лаб в одной инфраструктуре) - РЕКОМЕНДУЕТСЯ
./run-lab.sh -l 7 -a apply -y

# Показать справку
./run-lab.sh -h
```

### Ручной запуск

Если вы предпочитаете запускать Terraform напрямую:

```bash
# Lab 1
cd labs/lab1-docker-jenkins
terraform init
terraform plan
terraform apply -auto-approve

# Lab 2
cd labs/lab2-aws-ec2
terraform init
terraform plan
terraform apply -auto-approve
```

## Описание лаб

### Lab 1: Docker + Jenkins
- **Цель**: Управление локальными (контейнерными) ресурсами
- **Провайдер**: Docker
- **Что создается**: Jenkins контейнер с томом для данных

### Lab 2: AWS EC2 Basic
- **Цель**: Знакомство с облачным провайдером AWS
- **Провайдер**: AWS
- **Что создается**: Простой EC2 инстанс на Ubuntu

### Lab 3: Variables, Locals, Outputs
- **Цель**: Сделать конфигурацию гибкой и переиспользуемой
- **Провайдер**: AWS
- **Что создается**: EC2 инстансы с использованием переменных, locals, .tfvars файлов

### Lab 4: IAM Users, Groups, Policies
- **Цель**: Управление доступом в AWS
- **Провайдер**: AWS
- **Что создается**: IAM пользователи, группы, политики доступа

### Lab 5: VPC и Dynamic Blocks
- **Цель**: Создание полноценной защищенной сети
- **Провайдер**: AWS
- **Что создается**: VPC, подсети, NAT gateways, Security Groups с dynamic blocks

### Lab 6: Data Sources
- **Цель**: Получение данных о существующих ресурсах
- **Провайдер**: AWS, Local
- **Что создается**: Нет новых ресурсов, только чтение существующих через data sources

### Lab Complete: Все 6 лаб в одной инфраструктуре ⭐
- **Цель**: Объединить все темы в единую работающую систему
- **Провайдеры**: Docker, AWS, Local, TLS
- **Что создается**:
  - **Lab 6**: Data sources для AMI и информации о регионе
  - **Lab 5**: VPC с публичной/приватной подсетями, NAT, Security Groups с dynamic blocks
  - **Lab 4**: IAM роли для EC2, пользователи, группы, политики
  - **Lab 2+3**: EC2 инстансы в приватной сети + Bastion хост, переменные окружений
  - **Lab 1**: Jenkins в Docker локально
  - **Lab 3**: Все через variables, locals, outputs, .tfvars файлы
- **Сценарий**: Jenkins управляет деплоем на EC2 в защищенной VPC

## Требования

- Terraform >= 1.5.0
- AWS CLI (для лаб 2-6)
- Настроенные AWS credentials (`aws configure`)
- Docker (для Lab 1)

## Очистка ресурсов

**Важно**: Всегда запускайте `destroy` после завершения работы с AWS лабами, чтобы избежать лишних трат!

```bash
# Уничтожить конкретную лабу
./run-lab.sh -l 2 -a destroy -y

# Уничтожить ПОЛНУЮ лабу (lab-complete)
./run-lab.sh -l 7 -a destroy -y

# Или вручную
cd labs/lab2-aws-ec2
terraform destroy -auto-approve

cd labs/lab-complete
terraform destroy -auto-approve
```
