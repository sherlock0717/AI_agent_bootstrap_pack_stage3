param(
  [string]$SessionTitle = "系统日启动"
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Start Day ===" -ForegroundColor Cyan

& (Join-Path $PSScriptRoot "run_system_check.ps1")
& (Join-Path $PSScriptRoot "start_system_session.ps1") -Title $SessionTitle

$decisionIndex = Join-Path $root "knowledge\decisions\_index.md"
if (Test-Path $decisionIndex) {
  Write-Host ""
  Write-Host "Decision index path:" -ForegroundColor Yellow
  Write-Host $decisionIndex
}

Write-Host ""
Write-Host "Start-of-day routine completed." -ForegroundColor Green
