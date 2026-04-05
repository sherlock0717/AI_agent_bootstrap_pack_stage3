param(
  [string]$Title = "未命名会话"
)

$root = Split-Path -Parent $PSScriptRoot
$sessionDir = Join-Path $root "knowledge\sessions"
New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $sessionDir "$timestamp.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 背景:
- 本次操作:
- 结果:
- 下一步:

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created session note: $file" -ForegroundColor Green
