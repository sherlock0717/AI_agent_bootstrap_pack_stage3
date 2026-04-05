param(
  [Parameter(Mandatory=$true)][string]$ProjectName
)

$root = Split-Path -Parent $PSScriptRoot
$projectDir = Join-Path $root ("deliverables\projects\" + $ProjectName)

New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

$readmePath = Join-Path $projectDir "README.md"
if (!(Test-Path $readmePath)) {
  $content = @"
# $ProjectName Deliverables

这里保存 $ProjectName 的交付物草稿与正式稿。

说明：
- 这里是交付物层，不是项目代码仓库
- 这里不等于 knowledge
- 这里也不等于 outputs
- 建议把最终需要反复使用或交付的内容放在这里
"@
  Set-Content -Path $readmePath -Value $content -Encoding UTF8
}

Write-Host "Initialized deliverables directory: $projectDir" -ForegroundColor Green
