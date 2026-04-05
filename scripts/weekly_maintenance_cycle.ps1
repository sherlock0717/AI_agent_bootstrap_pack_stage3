param(
  [string]$WeeklyReviewTitle = "系统每周维护回顾",
  [string]$ScoutReviewTitle = "本周技术雷达复盘",
  [switch]$SkipScoutReview,
  [switch]$SkipArchiveDryRun
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Weekly Maintenance Cycle ===" -ForegroundColor Cyan

# 1. preflight
& (Join-Path $PSScriptRoot "preflight_check.ps1")

# 2. maintenance cycle
if ($SkipArchiveDryRun) {
  & (Join-Path $PSScriptRoot "run_maintenance_cycle.ps1") -SkipArchiveDryRun
} else {
  & (Join-Path $PSScriptRoot "run_maintenance_cycle.ps1")
}

# 3. weekly review
& (Join-Path $PSScriptRoot "weekly_review.ps1") -Title $WeeklyReviewTitle

# 4. scout review
if (-not $SkipScoutReview) {
  try {
    & (Join-Path $PSScriptRoot "review_latest_scout.ps1") -Title $ScoutReviewTitle
  }
  catch {
    Write-Host "Scout review skipped due to error: $($_.Exception.Message)" -ForegroundColor Yellow
  }
}

# 5. refresh indexes
& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

Write-Host ""
Write-Host "Weekly maintenance cycle completed." -ForegroundColor Green
