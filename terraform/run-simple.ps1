# Terraform Labs Runner (Simplified)
param(
    [int]$Lab = 7,
    [string]$Action = "plan"
)

$labs = @{
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
$dir = Join-Path $scriptDir $labs[$Lab]

Write-Host "Lab: $Lab" -ForegroundColor Green
Write-Host "Dir: $dir" -ForegroundColor Green
Write-Host "Action: $Action" -ForegroundColor Green

Set-Location $dir

switch ($Action) {
    "init" { terraform init }
    "plan" { 
        terraform init
        terraform plan 
    }
    "apply" { 
        terraform init
        terraform plan
        terraform apply -auto-approve 
    }
    "destroy" { terraform destroy -auto-approve }
}

Set-Location $scriptDir
Write-Host "Done!" -ForegroundColor Green
