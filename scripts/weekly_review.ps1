param(
  [string]$Title = "系统每周回顾"
)

$root = Split-Path -Parent $PSScriptRoot
$reviewDir = Join-Path $root "knowledge\system\reviews"
New-Item -ItemType Directory -Path $reviewDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $reviewDir "$timestamp-weekly_review.md"

function Get-LatestNotes {
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

$sessionFiles = Get-LatestNotes -Path (Join-Path $root "knowledge\sessions")
$decisionFiles = Get-LatestNotes -Path (Join-Path $root "knowledge\decisions")
$systemFiles = Get-LatestNotes -Path (Join-Path $root "knowledge\system")
$scoutFiles = Get-LatestNotes -Path (Join-Path $root "knowledge\system\tech_watch")

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: weekly_review

## 本周仓库状态
$gitStatus

## 最近提交
$gitLog

## 最近系统笔记
$(
if ($systemFiles.Count -eq 0) {
  "- 无"
} else {
  ($systemFiles | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近会话记录
$(
if ($sessionFiles.Count -eq 0) {
  "- 无"
} else {
  ($sessionFiles | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近决策记录
$(
if ($decisionFiles.Count -eq 0) {
  "- 无"
} else {
  ($decisionFiles | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近技术雷达笔记
$(
if ($scoutFiles.Count -eq 0) {
  "- 无"
} else {
  ($scoutFiles | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 本周总结
- 做成了什么：
- 哪些结构更稳定了：
- 哪些地方仍然混乱：
- 下周最优先事项：

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created weekly review: $file" -ForegroundColor Green
