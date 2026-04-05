param()

$root = Split-Path -Parent $PSScriptRoot
$dashboardDir = Join-Path $root "outputs\dashboards"
New-Item -ItemType Directory -Path $dashboardDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $dashboardDir "$timestamp-daily_dashboard.md"

function Get-LatestMarkdown {
  param(
    [string]$Path,
    [int]$Count = 5
  )

  if (!(Test-Path $Path)) { return @() }

  Get-ChildItem -Path $Path -File -Filter "*.md" |
    Where-Object { $_.Name -notin @("README.md","_index.md") } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First $Count
}

$gitStatus = git -C $root status --short | Out-String
if ([string]::IsNullOrWhiteSpace($gitStatus)) {
  $gitStatus = "working tree clean"
}

$gitLog = git -C $root log --oneline -n 5 | Out-String

$projects = Get-ChildItem -Path (Join-Path $root "projects") -Directory |
  Where-Object { $_.Name -notlike "_*" -and $_.Name -notlike ".*" } |
  Sort-Object Name

$latestSessions = Get-LatestMarkdown -Path (Join-Path $root "knowledge\sessions")
$latestDecisions = Get-LatestMarkdown -Path (Join-Path $root "knowledge\decisions")
$latestReviews = Get-LatestMarkdown -Path (Join-Path $root "knowledge\system\reviews")
$latestScout = Get-LatestMarkdown -Path (Join-Path $root "knowledge\system\tech_watch")
$latestSystemNotes = Get-LatestMarkdown -Path (Join-Path $root "knowledge\system")

$content = @"
# Daily Dashboard

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: daily_dashboard

## Git 状态
$gitStatus

## 最近提交
$gitLog

## 当前接入项目
$(
if ($projects.Count -eq 0) {
  "- 无"
} else {
  ($projects | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近系统笔记
$(
if ($latestSystemNotes.Count -eq 0) {
  "- 无"
} else {
  ($latestSystemNotes | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近会话
$(
if ($latestSessions.Count -eq 0) {
  "- 无"
} else {
  ($latestSessions | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近决策
$(
if ($latestDecisions.Count -eq 0) {
  "- 无"
} else {
  ($latestDecisions | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近复盘
$(
if ($latestReviews.Count -eq 0) {
  "- 无"
} else {
  ($latestReviews | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近技术雷达笔记
$(
if ($latestScout.Count -eq 0) {
  "- 无"
} else {
  ($latestScout | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 今日建议
- 是否需要开启一次系统会话？
- 是否需要补一条 system note 或 decision note？
- 是否需要整理 outputs 或归档旧结果？
- 是否需要发布一次 snapshot？

"@

Set-Content -Path $file -Value $content -Encoding UTF8

Write-Host ""
Write-Host "=== Daily Dashboard ===" -ForegroundColor Cyan
Write-Host "Dashboard file: $file" -ForegroundColor Green
Write-Host ""

Write-Host "Current projects:" -ForegroundColor Yellow
if ($projects.Count -eq 0) {
  Write-Host "- 无"
} else {
  $projects | ForEach-Object { Write-Host ("- " + $_.Name) }
}

Write-Host ""
Write-Host "Latest reviews:" -ForegroundColor Yellow
if ($latestReviews.Count -eq 0) {
  Write-Host "- 无"
} else {
  $latestReviews | ForEach-Object { Write-Host ("- " + $_.Name) }
}
