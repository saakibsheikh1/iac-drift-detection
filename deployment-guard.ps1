$ErrorActionPreference = "Stop"

$InfrastructurePath = Join-Path $PSScriptRoot "infrastructure"

Write-Host "========================================="
Write-Host "       DEPLOYMENT DRIFT GUARDRAIL"
Write-Host "========================================="
Write-Host ""

Set-Location $InfrastructurePath

terraform plan -input=false -detailed-exitcode -no-color

$ExitCode = $LASTEXITCODE

Write-Host ""

if ($ExitCode -eq 0) {
    Write-Host "DRIFT CHECK PASSED"
    Write-Host "No unresolved infrastructure drift detected."
    Write-Host "Deployment is allowed."
    exit 0
}
elseif ($ExitCode -eq 2) {
    Write-Host "========================================="
    Write-Host "DEPLOYMENT BLOCKED"
    Write-Host "========================================="
    Write-Host ""
    Write-Host "Unresolved infrastructure drift detected."
    Write-Host "Terraform configuration does not match"
    Write-Host "the live AWS infrastructure."
    Write-Host ""
    Write-Host "Remediate the drift before deployment."
    exit 1
}
else {
    Write-Host "DRIFT CHECK FAILED"
    Write-Host "Terraform returned an error."
    exit 1
}