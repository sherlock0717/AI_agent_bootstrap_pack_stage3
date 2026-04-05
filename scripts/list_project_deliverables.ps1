param(
  [Parameter(Mandatory=$true)][string]$ProjectName
)

$root = Split-Path -Parent $PSScriptRoot
$projectDir = Join-Path $root ("deliverables\projects\" + $ProjectName)

if (!(Test-Path $projectDir)) {
  throw "Deliverables directory not found: $projectDir"
}

Write-Host ""
Write-Host "=== Deliverables for $ProjectName ===" -ForegroundColor Cyan

Get-ChildItem -Path $projectDir -File |
  Sort-Object LastWriteTime -Descending |
  Select-Object Name, LastWriteTime
