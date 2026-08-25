$ErrorActionPreference = "Stop"

$InfrastructurePath = Join-Path $PSScriptRoot "..\infrastructure"

Write-Host "========================================="
Write-Host "       IaC DRIFT DETECTION SCAN"
Write-Host "========================================="
Write-Host ""

Set-Location $InfrastructurePath

Write-Host "[1/3] Initializing Terraform..."
terraform init -input=false

Write-Host ""
Write-Host "[2/3] Running drift detection..."
terraform plan -input=false -detailed-exitcode -no-color

$ExitCode = $LASTEXITCODE

Write-Host ""
Write-Host "========================================="

if ($ExitCode -eq 0) {
    Write-Host "RESULT: NO DRIFT DETECTED"
    Write-Host "Infrastructure matches Terraform."
    exit 0
}
elseif ($ExitCode -eq 2) {
    Write-Host "RESULT: DRIFT DETECTED"
    Write-Host "Terraform detected infrastructure changes."
    Write-Host "Review the plan above for the affected resource and attribute."
    exit 2
}
else {
    Write-Host "RESULT: SCAN FAILED"
    Write-Host "Terraform returned an unexpected error."
    exit $ExitCode
}