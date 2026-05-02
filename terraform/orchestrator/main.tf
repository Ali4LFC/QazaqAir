# Terraform Labs Orchestrator
# Позволяет выбирать и запускать любую лабораторную работу одним запуском

# =============================================================================
# VARIABLES
# =============================================================================

variable "selected_lab" {
  description = "Номер лабораторной работы для запуска (1-6). Используйте 0 чтобы запустить все."
  type        = number
  default     = 1

  validation {
    condition     = var.selected_lab >= 0 && var.selected_lab <= 6
    error_message = "Номер лабы должен быть от 0 (все) до 6."
  }
}

variable "action" {
  description = "Действие: apply, destroy, или plan"
  type        = string
  default     = "plan"

  validation {
    condition     = contains(["apply", "destroy", "plan"], var.action)
    error_message = "Действие должно быть apply, destroy или plan."
  }
}

# =============================================================================
# LOCALS - Определение путей к лабам
# =============================================================================

locals {
  labs = {
    "1" = {
      name = "Lab 1: Docker + Jenkins"
      path = "../labs/lab1-docker-jenkins"
    }
    "2" = {
      name = "Lab 2: AWS EC2 Basic"
      path = "../labs/lab2-aws-ec2"
    }
    "3" = {
      name = "Lab 3: Variables, Locals, Outputs"
      path = "../labs/lab3-variables"
    }
    "4" = {
      name = "Lab 4: IAM Users, Groups, Policies"
      path = "../labs/lab4-iam"
    }
    "5" = {
      name = "Lab 5: VPC и Dynamic Blocks"
      path = "../labs/lab5-vpc"
    }
    "6" = {
      name = "Lab 6: Data Sources"
      path = "../labs/lab6-data-sources"
    }
  }

  selected_labs = var.selected_lab == 0 ? keys(local.labs) : [tostring(var.selected_lab)]
}

# =============================================================================
# MODULES - Вызов выбранных лаб
# =============================================================================

module "lab1" {
  count  = contains(local.selected_labs, "1") ? 1 : 0
  source = "../labs/lab1-docker-jenkins"
}

module "lab2" {
  count  = contains(local.selected_labs, "2") ? 1 : 0
  source = "../labs/lab2-aws-ec2"
}

module "lab3" {
  count  = contains(local.selected_labs, "3") ? 1 : 0
  source = "../labs/lab3-variables"
}

module "lab4" {
  count  = contains(local.selected_labs, "4") ? 1 : 0
  source = "../labs/lab4-iam"
}

module "lab5" {
  count  = contains(local.selected_labs, "5") ? 1 : 0
  source = "../labs/lab5-vpc"
}

module "lab6" {
  count  = contains(local.selected_labs, "6") ? 1 : 0
  source = "../labs/lab6-data-sources"
}
