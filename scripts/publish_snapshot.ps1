param(
  [Parameter(Mandatory=$true)][string]$Message
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Publish Snapshot ===" -ForegroundColor Cyan

git -C $root status --short
git -C $root add .

$hasChanges = git -C $root diff --cached --name-only
if (-not $hasChanges) {
  Write-Host "No staged changes to commit." -ForegroundColor Yellow
  exit 0
}

git -C $root commit -m $Message
git -C $root push

Write-Host ""
Write-Host "Publish completed." -ForegroundColor Green
