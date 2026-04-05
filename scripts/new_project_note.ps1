param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [string]$Title = "未命名项目笔记"
)

$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root ("knowledge\projects\" + $ProjectName)
New-Item -ItemType Directory -Path $dir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$file = Join-Path $dir "$timestamp-$safeTitle.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: project_note
- 项目: $ProjectName
- 背景:
- 内容:
- 影响:
- 下一步:

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created project note: $file" -ForegroundColor Green
