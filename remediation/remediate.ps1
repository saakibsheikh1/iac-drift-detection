$ErrorActionPreference = "Stop"

$InfrastructurePath = Join-Path $PSScriptRoot "..\infrastructure"

Write-Host "========================================="
Write-Host "          IaC DRIFT REMEDIATION"
Write-Host "========================================="
Write-Host ""

Set-Location $InfrastructurePath

Write-Host "[1/2] Initializing Terraform..."
terraform init -input=false

Write-Host ""
Write-Host "[2/2] Applying code-defined state..."
terraform apply -auto-approve

Write-Host ""
Write-Host "========================================="
Write-Host "RESULT: REMEDIATION COMPLETE"
Write-Host "========================================="