param(
  [string]$SourceFile = "",
  [string]$Title = "未命名仪表盘归档"
)

$root = Split-Path -Parent $PSScriptRoot
$outputDir = Join-Path $root "outputs\dashboards"
$knowledgeDir = Join-Path $root "knowledge\system\dashboards"

New-Item -ItemType Directory -Path $knowledgeDir -Force | Out-Null

if ([string]::IsNullOrWhiteSpace($SourceFile)) {
  if (!(Test-Path $outputDir)) {
    throw "Dashboard 输出目录不存在: $outputDir"
  }

  $latest = Get-ChildItem -Path $outputDir -File -Filter "*.md" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

  if ($null -eq $latest) {
    throw "没有找到任何 dashboard 输出文件。"
  }

  $SourceFile = $latest.FullName
}

if (!(Test-Path $SourceFile)) {
  throw "指定的 SourceFile 不存在: $SourceFile"
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$targetFile = Join-Path $knowledgeDir "$timestamp-$safeTitle.md"

$sourceContent = Get-Content -Path $SourceFile -Raw -Encoding UTF8

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: dashboard_archive
- 来源文件: $SourceFile

## 仪表盘内容

$sourceContent

## 后续说明
- 为什么这份 dashboard 值得长期保留：
- 后续会在哪些场景再次引用：
- 是否需要补充 system note / decision note：

"@

Set-Content -Path $targetFile -Value $content -Encoding UTF8
Write-Host "Promoted dashboard to knowledge: $targetFile" -ForegroundColor Green
