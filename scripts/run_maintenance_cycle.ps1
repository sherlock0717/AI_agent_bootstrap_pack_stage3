param(
  [switch]$SkipArchiveDryRun
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Maintenance Cycle ===" -ForegroundColor Cyan

# 1. system health
& (Join-Path $PSScriptRoot "run_system_check.ps1")

# 2. config validation
$stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$outJson = Join-Path $root ("outputs\health\" + $stamp + "-config_validation.json")
$outMd = Join-Path $root ("outputs\health\" + $stamp + "-config_validation.md")
& (Join-Path $PSScriptRoot "validate_configs.ps1") -OutputJson $outJson -OutputMd $outMd

# 3. refresh indexes
& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

# 4. dashboard
& (Join-Path $PSScriptRoot "daily_dashboard.ps1")

# 5. archive dry-run
if (-not $SkipArchiveDryRun) {
  & (Join-Path $PSScriptRoot "archive_old_outputs.ps1") -DaysOld 7 -DryRun
}

Write-Host ""
Write-Host "Maintenance cycle completed." -ForegroundColor Green
