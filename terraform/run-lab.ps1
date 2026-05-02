# Terraform Labs Runner Script
# Запускает выбранную лабораторную работу одной командой

param(
    [Parameter(Mandatory=$false)]
    [ValidateRange(0, 7)]
    [int]$LabNumber = 7,

    [Parameter(Mandatory=$false)]
    [ValidateSet("init", "plan", "apply", "destroy", "validate", "fmt")]
    [string]$Action = "plan",

    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove = $false,

    [Parameter(Mandatory=$false)]
    [switch]$Help = $false
)

$ErrorActionPreference = "Stop"

# Справка
if ($Help) {
    @"
Использование: .\run-lab.ps1 [-LabNumber <0-6>] [-Action <init|plan|apply|destroy|validate|fmt>] [-AutoApprove]

Параметры:
  -LabNumber    Номер лабораторной работы (1-6). 0 = все лабы. 7 = полная лаба.
  -Action       Действие Terraform (init, plan, apply, destroy, validate, fmt)
  -AutoApprove  Автоматическое подтверждение для apply/destroy
  -Help         Показать эту справку

Примеры:
  # Запуск Lab 1
  .\run-lab.ps1 -LabNumber 1 -Action apply -AutoApprove

  # Планирование Lab 3
  .\run-lab.ps1 -LabNumber 3 -Action plan

  # Уничтожение Lab 2
  .\run-lab.ps1 -LabNumber 2 -Action destroy -AutoApprove

  # Запуск всех лаб
  .\run-lab.ps1 -LabNumber 0 -Action apply

Доступные лабораторные работы:
  0: Orchestrator (все лабы через модули)
  1: Docker + Jenkins (локальные контейнеры)
  2: AWS EC2 Basic (базовый инстанс)
  3: Variables, Locals, Outputs (гибкая конфигурация)
  4: IAM Users, Groups, Policies (управление доступом)
  5: VPC и Dynamic Blocks (сетевая инфраструктура)
  6: Data Sources (чтение существующих ресурсов)
  7: COMPLETE - Все лабы в одной инфраструктуре (Jenkins + EC2 + VPC + IAM)
"@
    exit 0
}

# Описание лаб
$labs = @{
    0 = "All Labs (Orchestrator)"
    1 = "Lab 1: Docker + Jenkins"
    2 = "Lab 2: AWS EC2 Basic"
    3 = "Lab 3: Variables, Locals, Outputs"
    4 = "Lab 4: IAM Users, Groups, Policies"
    5 = "Lab 5: VPC and Dynamic Blocks"
    6 = "Lab 6: Data Sources"
    7 = "Lab Complete: All 6 labs in one infrastructure"
}

# Определение пути к лабе
$labPaths = @{
    0 = "orchestrator"
    1 = "labs/lab1-docker-jenkins"
    2 = "labs/lab2-aws-ec2"
    3 = "labs/lab3-variables"
    4 = "labs/lab4-iam"
    5 = "labs/lab5-vpc"
    6 = "labs/lab6-data-sources"
    7 = "labs/lab-complete"
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$terraformDir = Join-Path $scriptDir $labPaths[$LabNumber]

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Terraform Labs Runner" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Selected: $($labs[$LabNumber])" -ForegroundColor Green
Write-Host "Action: $Action" -ForegroundColor Green
Write-Host "Directory: $terraformDir" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan

# Проверка существования директории
if (-not (Test-Path $terraformDir)) {
    Write-Error "Директория не найдена: $terraformDir"
    exit 1
}

# Переход в директорию
Set-Location $terraformDir

# Выполнение действия
switch ($Action) {
    "init" {
        Write-Host "`n[1/1] Initializing Terraform..." -ForegroundColor Yellow
        terraform init
    }

    "validate" {
        Write-Host "`n[1/1] Validating Terraform configuration..." -ForegroundColor Yellow
        terraform validate
    }

    "fmt" {
        Write-Host "`n[1/1] Formatting Terraform files..." -ForegroundColor Yellow
        terraform fmt -recursive
    }

    "plan" {
        Write-Host "`n[1/2] Initializing Terraform..." -ForegroundColor Yellow
        terraform init

        Write-Host "`n[2/2] Running terraform plan..." -ForegroundColor Yellow
        if ($LabNumber -eq 0) {
            terraform plan -var="selected_lab=0"
        } else {
            terraform plan
        }
    }

    "apply" {
        Write-Host "`n[1/3] Initializing Terraform..." -ForegroundColor Yellow
        terraform init

        Write-Host "`n[2/3] Running terraform plan..." -ForegroundColor Yellow
        if ($LabNumber -eq 0) {
            terraform plan -var="selected_lab=0"
        } else {
            terraform plan
        }

        Write-Host "`n[3/3] Applying changes..." -ForegroundColor Yellow
        $approveFlag = if ($AutoApprove) { "-auto-approve" } else { "" }
        if ($LabNumber -eq 0) {
            Invoke-Expression "terraform apply $approveFlag -var='selected_lab=0'"
        } else {
            Invoke-Expression "terraform apply $approveFlag"
        }
    }

    "destroy" {
        Write-Host "`n[!] WARNING: This will destroy resources!" -ForegroundColor Red

        if (-not $AutoApprove) {
            $confirm = Read-Host "Are you sure? Type 'yes' to continue"
            if ($confirm -ne "yes") {
                Write-Host "Cancelled." -ForegroundColor Yellow
                exit 0
            }
        }

        Write-Host "`n[1/1] Destroying resources..." -ForegroundColor Yellow
        $approveFlag = if ($AutoApprove) { "-auto-approve" } else { "" }
        if ($LabNumber -eq 0) {
            Invoke-Expression "terraform destroy $approveFlag -var='selected_lab=0'"
        } else {
            Invoke-Expression "terraform destroy $approveFlag"
        }
    }
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  Complete!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan

# Возврат в исходную директорию
Set-Location $scriptDir
