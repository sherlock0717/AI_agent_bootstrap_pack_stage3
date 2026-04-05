param(
  [string]$SourceDir = "",
  [string]$Title = "未命名技术观察"
)

$root = Split-Path -Parent $PSScriptRoot
$manualRunDir = Join-Path $root "outputs\scout\manual_run"
$knowledgeDir = Join-Path $root "knowledge\system\tech_watch"

New-Item -ItemType Directory -Path $knowledgeDir -Force | Out-Null

if ([string]::IsNullOrWhiteSpace($SourceDir)) {
  if (!(Test-Path $manualRunDir)) {
    throw "Scout 输出目录不存在: $manualRunDir"
  }

  $latest = Get-ChildItem -Path $manualRunDir -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($null -eq $latest) {
    throw "没有找到任何 scout 输出目录。"
  }

  $SourceDir = $latest.FullName
}

$summaryFile = Join-Path $SourceDir "summary.md"
if (!(Test-Path $summaryFile)) {
  throw "未找到 summary.md: $summaryFile"
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$targetFile = Join-Path $knowledgeDir "$timestamp-$safeTitle.md"

$summaryContent = Get-Content -Path $summaryFile -Raw -Encoding UTF8

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: tech_watch_note
- 来源目录: $SourceDir

## 摘要内容

$summaryContent

## 后续处理
- 哪些值得继续跟踪：
- 哪些需要测试：
- 哪些对系统配置有影响：

"@

Set-Content -Path $targetFile -Value $content -Encoding UTF8
Write-Host "Promoted scout summary to knowledge: $targetFile" -ForegroundColor Green
