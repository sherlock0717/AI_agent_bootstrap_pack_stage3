param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [string]$Title = "未命名项目会话"
)

$root = Split-Path -Parent $PSScriptRoot
$sessionDir = Join-Path $root ("knowledge\projects\" + $ProjectName + "\sessions")
New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $sessionDir "$timestamp.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 项目: $ProjectName
- 背景:
- 本次操作:
- 结果:
- 下一步:

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created project session note: $file" -ForegroundColor Green
