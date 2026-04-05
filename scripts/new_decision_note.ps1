param(
  [string]$Title = "未命名决策",
  [string]$Status = "draft"
)

$root = Split-Path -Parent $PSScriptRoot
$decisionDir = Join-Path $root "knowledge\decisions"
New-Item -ItemType Directory -Path $decisionDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$file = Join-Path $decisionDir "$timestamp-$safeTitle.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 状态: $Status
- 背景:
- 决策:
- 原因:
- 影响:
- 后续动作:

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created decision note: $file" -ForegroundColor Green
