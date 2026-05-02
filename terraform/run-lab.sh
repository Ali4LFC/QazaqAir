#!/bin/bash
# Terraform Labs Runner Script (Linux/Mac)
# Запускает выбранную лабораторную работу одной командой

set -e

# Цвета для вывода
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Параметры по умолчанию
LAB_NUMBER=0
ACTION="plan"
AUTO_APPROVE=false

# Справка
show_help() {
    cat << EOF
Использование: ./run-lab.sh [-l <0-6>] [-a <init|plan|apply|destroy|validate|fmt>] [-y] [-h]

Параметры:
  -l LAB    Номер лабораторной работы (1-6). 0 = все лабы. 7 = полная лаба.
  -a ACTION Действие Terraform (init, plan, apply, destroy, validate, fmt)
  -y        Автоматическое подтверждение для apply/destroy
  -h        Показать эту справку

Примеры:
  # Запуск Lab 1
  ./run-lab.sh -l 1 -a apply -y

  # Планирование Lab 3
  ./run-lab.sh -l 3 -a plan

  # Уничтожение Lab 2
  ./run-lab.sh -l 2 -a destroy -y

  # Запуск всех лаб
  ./run-lab.sh -l 0 -a apply

Доступные лабораторные работы:
  0: Orchestrator (все лабы через модули)
  1: Docker + Jenkins (локальные контейнеры)
  2: AWS EC2 Basic (базовый инстанс)
  3: Variables, Locals, Outputs (гибкая конфигурация)
  4: IAM Users, Groups, Policies (управление доступом)
  5: VPC и Dynamic Blocks (сетевая инфраструктура)
  6: Data Sources (чтение существующих ресурсов)
  7: COMPLETE - Все лабы в одной инфраструктуре (Jenkins + EC2 + VPC + IAM)
EOF
}

# Разбор параметров
while getopts "l:a:yh" opt; do
    case $opt in
        l) LAB_NUMBER="$OPTARG" ;;
        \?)
            echo "Неверный параметр: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        a) ACTION="$OPTARG" ;;
        y) AUTO_APPROVE=true ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

# Проверка диапазона лабы
if [[ $LAB_NUMBER -lt 0 || $LAB_NUMBER -gt 7 ]]; then
    echo -e "${RED}Ошибка: Номер лабы должен быть от 0 до 7${NC}"
    exit 1
fi

# Описание лаб
declare -A LABS
LABS[0]="All Labs (Orchestrator)"
LABS[1]="Lab 1: Docker + Jenkins"
LABS[2]="Lab 2: AWS EC2 Basic"
LABS[3]="Lab 3: Variables, Locals, Outputs"
LABS[4]="Lab 4: IAM Users, Groups, Policies"
LABS[5]="Lab 5: VPC и Dynamic Blocks"
LABS[6]="Lab 6: Data Sources"
LABS[7]="Lab Complete: Все лабы в одной инфраструктуре"

# Пути к лабам
declare -A LAB_PATHS
LAB_PATHS[0]="orchestrator"
LAB_PATHS[1]="labs/lab1-docker-jenkins"
LAB_PATHS[2]="labs/lab2-aws-ec2"
LAB_PATHS[3]="labs/lab3-variables"
LAB_PATHS[4]="labs/lab4-iam"
LAB_PATHS[5]="labs/lab5-vpc"
LAB_PATHS[6]="labs/lab6-data-sources"
LAB_PATHS[7]="labs/lab-complete"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/${LAB_PATHS[$LAB_NUMBER]}"

# Вывод информации
echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  Terraform Labs Runner${NC}"
echo -e "${CYAN}======================================${NC}"
echo -e "${GREEN}Selected: ${LABS[$LAB_NUMBER]}${NC}"
echo -e "${GREEN}Action: $ACTION${NC}"
echo -e "${GREEN}Directory: $TERRAFORM_DIR${NC}"
echo -e "${CYAN}======================================${NC}"

# Проверка существования директории
if [[ ! -d "$TERRAFORM_DIR" ]]; then
    echo -e "${RED}Ошибка: Директория не найдена: $TERRAFORM_DIR${NC}"
    exit 1
fi

# Переход в директорию
cd "$TERRAFORM_DIR"

# Выполнение действия
case $ACTION in
    init)
        echo -e "\n${YELLOW}[1/1] Initializing Terraform...${NC}"
        terraform init
        ;;

    validate)
        echo -e "\n${YELLOW}[1/1] Validating Terraform configuration...${NC}"
        terraform validate
        ;;

    fmt)
        echo -e "\n${YELLOW}[1/1] Formatting Terraform files...${NC}"
        terraform fmt -recursive
        ;;

    plan)
        echo -e "\n${YELLOW}[1/2] Initializing Terraform...${NC}"
        terraform init

        echo -e "\n${YELLOW}[2/2] Running terraform plan...${NC}"
        if [[ $LAB_NUMBER -eq 0 ]]; then
            terraform plan -var="selected_lab=0"
        else
            terraform plan
        fi
        ;;

    apply)
        echo -e "\n${YELLOW}[1/3] Initializing Terraform...${NC}"
        terraform init

        echo -e "\n${YELLOW}[2/3] Running terraform plan...${NC}"
        if [[ $LAB_NUMBER -eq 0 ]]; then
            terraform plan -var="selected_lab=0"
        else
            terraform plan
        fi

        echo -e "\n${YELLOW}[3/3] Applying changes...${NC}"
        APPROVE_FLAG=""
        if [[ $AUTO_APPROVE == true ]]; then
            APPROVE_FLAG="-auto-approve"
        fi
        if [[ $LAB_NUMBER -eq 0 ]]; then
            terraform apply $APPROVE_FLAG -var="selected_lab=0"
        else
            terraform apply $APPROVE_FLAG
        fi
        ;;

    destroy)
        echo -e "\n${RED}[!] WARNING: This will destroy resources!${NC}"

        if [[ $AUTO_APPROVE == false ]]; then
            read -p "Are you sure? Type 'yes' to continue: " confirm
            if [[ $confirm != "yes" ]]; then
                echo -e "${YELLOW}Cancelled.${NC}"
                exit 0
            fi
        fi

        echo -e "\n${YELLOW}[1/1] Destroying resources...${NC}"
        APPROVE_FLAG=""
        if [[ $AUTO_APPROVE == true ]]; then
            APPROVE_FLAG="-auto-approve"
        fi
        if [[ $LAB_NUMBER -eq 0 ]]; then
            terraform destroy $APPROVE_FLAG -var="selected_lab=0"
        else
            terraform destroy $APPROVE_FLAG
        fi
        ;;

    *)
        echo -e "${RED}Неизвестное действие: $ACTION${NC}"
        show_help
        exit 1
        ;;
esac

echo -e "\n${CYAN}======================================${NC}"
echo -e "${GREEN}  Complete!${NC}"
echo -e "${CYAN}======================================${NC}"
