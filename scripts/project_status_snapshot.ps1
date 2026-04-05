param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [string]$Title = "项目状态快照"
)

$root = Split-Path -Parent $PSScriptRoot

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

Write-Host ""
Write-Host "=== Project Status Snapshot ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectName" -ForegroundColor Yellow

$projectKnowledgeDir = Join-Path $root ("knowledge\projects\" + $ProjectName)
$projectSessionsDir = Join-Path $projectKnowledgeDir "sessions"
$projectReviewsDir = Join-Path $projectKnowledgeDir "reviews"
$projectDeliverablesDir = Join-Path $root ("deliverables\projects\" + $ProjectName)
$snapshotDir = Join-Path $projectKnowledgeDir "snapshots"

New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null

$latestProjectNotes = Get-LatestMarkdown -Path $projectKnowledgeDir
$latestProjectSessions = Get-LatestMarkdown -Path $projectSessionsDir
$latestProjectReviews = Get-LatestMarkdown -Path $projectReviewsDir
$latestDeliverables = Get-LatestMarkdown -Path $projectDeliverablesDir

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $snapshotDir ($timestamp + "-project_status_snapshot.md")

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 项目: $ProjectName
- 类型: project_status_snapshot

## 最近项目笔记
$(
if ($latestProjectNotes.Count -eq 0) {
  "- 无"
} else {
  ($latestProjectNotes | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近项目会话
$(
if ($latestProjectSessions.Count -eq 0) {
  "- 无"
} else {
  ($latestProjectSessions | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近项目复盘
$(
if ($latestProjectReviews.Count -eq 0) {
  "- 无"
} else {
  ($latestProjectReviews | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 最近交付物
$(
if ($latestDeliverables.Count -eq 0) {
  "- 无"
} else {
  ($latestDeliverables | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 当前状态判断
- 当前项目大致处于哪个阶段：
- 当前最重要的任务：
- 当前最重要的交付物：
- 当前主要阻塞：
- 下次接手时优先看的文件：

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created project status snapshot: $file" -ForegroundColor Green
