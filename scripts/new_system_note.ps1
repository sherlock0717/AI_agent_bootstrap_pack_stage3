param(
  [string]$Title = "未命名系统笔记"
)

$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root "knowledge\system"
New-Item -ItemType Directory -Path $dir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$file = Join-Path $dir "$timestamp-$safeTitle.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: system_note
- 背景:
- 内容:
- 影响:
- 下一步:

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created system note: $file" -ForegroundColor Green
