param(
  [string]$Title = "系统基线快照"
)

$root = Split-Path -Parent $PSScriptRoot
$releaseDir = Join-Path $root "knowledge\system\releases"
New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $releaseDir ($timestamp + "-system_release_snapshot.md")

$gitLog = git -C $root log --oneline -n 10 | Out-String
$branch = git -C $root branch --show-current | Out-String
$status = git -C $root status --short | Out-String
if ([string]::IsNullOrWhiteSpace($status)) {
  $status = "working tree clean"
}

$systemRoutesPath = Join-Path $root "config\system_routes.yaml"
$entryLines = @()
if (Test-Path $systemRoutesPath) {
  $entryLines = Select-String -Path $systemRoutesPath -Pattern '^\s+[a-zA-Z0-9_]+\s*:\s*".+"$' | ForEach-Object { $_.Line.Trim() }
}

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: system_release_snapshot
- 当前分支: $($branch.Trim())

## 当前仓库状态
$status

## 最近提交
$gitLog

## 当前标准入口
$(
if ($entryLines.Count -eq 0) {
  "- 无"
} else {
  ($entryLines | ForEach-Object { "- " + $_ }) -join "`r`n"
}
)

## 当前成熟度判断
- 当前是否已形成稳定核心：
- 当前哪些部分仍属于实验层：
- 当前最不该继续大改的部分：
- 下一阶段最值得推进的方向：

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created system release snapshot: $file" -ForegroundColor Green
