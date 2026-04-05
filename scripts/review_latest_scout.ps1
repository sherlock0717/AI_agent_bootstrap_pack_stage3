param(
  [string]$Title = "技术雷达复盘"
)

$root = Split-Path -Parent $PSScriptRoot
$scoutDir = Join-Path $root "knowledge\system\tech_watch"
$reviewDir = Join-Path $root "knowledge\system\reviews"

New-Item -ItemType Directory -Path $reviewDir -Force | Out-Null

$latest = Get-ChildItem -Path $scoutDir -File -Filter "*.md" |
  Where-Object { $_.Name -ne "README.md" } |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1

if ($null -eq $latest) {
  throw "没有找到可复盘的技术雷达笔记。"
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$file = Join-Path $reviewDir "$timestamp-scout_review.md"

$content = @"
# $Title

- 时间: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- 类型: scout_review
- 基于笔记: $($latest.Name)

## 复盘对象
$($latest.FullName)

## 需要回答的问题
- 这次 scout 里哪些内容最值得长期跟踪？
- 哪些值得进入系统规则、脚本或配置？
- 哪些只是短期信息，不需要长期保存？
- 哪些内容应该安排后续测试？

## 后续动作
- [ ] 更新 system note
- [ ] 更新 decision note
- [ ] 更新 task / tool routing
- [ ] 暂不处理

"@

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Created scout review note: $file" -ForegroundColor Green
