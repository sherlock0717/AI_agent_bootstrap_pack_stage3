param(
  [string]$DecisionTitle = ""
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Close Day ===" -ForegroundColor Cyan

if (-not [string]::IsNullOrWhiteSpace($DecisionTitle)) {
  & (Join-Path $PSScriptRoot "new_decision_note.ps1") -Title $DecisionTitle -Status "active"
}

& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

Write-Host ""
Write-Host "Git status:" -ForegroundColor Yellow
git -C $root status --short

Write-Host ""
Write-Host "Close-of-day routine completed." -ForegroundColor Green
