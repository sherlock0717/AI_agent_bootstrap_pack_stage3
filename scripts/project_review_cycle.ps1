param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [string]$Title = "项目周期复盘",
  [switch]$CreateProjectNote,
  [string]$ProjectNoteTitle = "项目复盘记录"
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
Write-Host "=== Project Review Cycle ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectName" -ForegroundColor Yellow

# 1. ensure deliverables dir exists
& (Join-Path $PSScriptRoot "init_project_deliverables.ps1") -ProjectName $ProjectName

# 2. collect paths
$projectKnowledgeDir = Join-Path $root ("knowledge\projects\" + $ProjectName)
$projectSessionsDir = Join-Path $projectKnowledgeDir "sessions"
$projectReviewsDir = Join-Path $projectKnowledgeDir "reviews"
$projectDeliverablesDir = Join-Path $root ("deliverables\projects\" + $ProjectName)

New-Item -ItemType Directory -Path $projectReviewsDir -Force | Out-Null

# 3. recent files
$latestProjectNotes = Get-LatestMarkdown -Path $projectKnowledgeDir
$latestProjectSessions = Get-LatestMarkdown -Path $projectSessionsDir
$latestDeliverables = Get-LatestMarkdown -Path $projectDeliverablesDir

# 4. generate review note
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $projectReviewsDir ($timestamp + "-project_review.md")

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 项目: $ProjectName
- 类型: project_review

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

## 最近交付物
$(
if ($latestDeliverables.Count -eq 0) {
  "- 无"
} else {
  ($latestDeliverables | ForEach-Object { "- " + $_.Name }) -join "`r`n"
}
)

## 本轮项目复盘
- 当前项目推进到了什么位置：
- 当前最重要的交付物是什么：
- 当前最需要补的知识或决策是什么：
- 当前最大的阻塞是什么：
- 下一步最优先动作：

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created project review: $file" -ForegroundColor Green

# 5. optional project note
if ($CreateProjectNote) {
  & (Join-Path $PSScriptRoot "new_project_note.ps1") `
    -ProjectName $ProjectName `
    -Title $ProjectNoteTitle
}

# 6. refresh indexes
& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

Write-Host ""
Write-Host "Project review cycle completed." -ForegroundColor Green
