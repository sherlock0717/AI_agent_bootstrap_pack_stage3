param()

$root = Split-Path -Parent $PSScriptRoot
$knowledgeRoot = Join-Path $root "knowledge"

function Get-MarkdownList {
  param(
    [string]$Path,
    [string[]]$ExcludeNames = @("README.md","_index.md")
  )

  if (!(Test-Path $Path)) { return @() }

  Get-ChildItem -Path $Path -File -Filter "*.md" |
    Where-Object { $ExcludeNames -notcontains $_.Name } |
    Sort-Object LastWriteTime -Descending
}

# system index
$systemDir = Join-Path $knowledgeRoot "system"
$systemFiles = Get-MarkdownList -Path $systemDir
$systemContent = "# System Index`r`n`r`n"
if ($systemFiles.Count -eq 0) {
  $systemContent += "当前还没有系统级笔记。`r`n"
} else {
  foreach ($file in $systemFiles) {
    $systemContent += "- $($file.Name)`r`n"
  }
}
Set-Content -Path (Join-Path $systemDir "_index.md") -Value $systemContent -Encoding UTF8

# projects index
$projectsDir = Join-Path $knowledgeRoot "projects"
$projectDirs = Get-ChildItem -Path $projectsDir -Directory | Sort-Object Name
$projectsContent = "# Projects Index`r`n`r`n"
if ($projectDirs.Count -eq 0) {
  $projectsContent += "当前还没有项目知识文件夹。`r`n"
} else {
  foreach ($dir in $projectDirs) {
    $projectsContent += "- $($dir.Name)`r`n"
  }
}
Set-Content -Path (Join-Path $projectsDir "_index.md") -Value $projectsContent -Encoding UTF8

# sessions index
$sessionsDir = Join-Path $knowledgeRoot "sessions"
$sessionFiles = Get-MarkdownList -Path $sessionsDir
$sessionsContent = "# Sessions Index`r`n`r`n"
if ($sessionFiles.Count -eq 0) {
  $sessionsContent += "当前还没有会话记录。`r`n"
} else {
  foreach ($file in ($sessionFiles | Select-Object -First 20)) {
    $sessionsContent += "- $($file.Name)`r`n"
  }
}
Set-Content -Path (Join-Path $sessionsDir "_index.md") -Value $sessionsContent -Encoding UTF8

# decisions index
$decisionsDir = Join-Path $knowledgeRoot "decisions"
$decisionFiles = Get-MarkdownList -Path $decisionsDir
$decisionsContent = "# Decisions Index`r`n`r`n"
if ($decisionFiles.Count -eq 0) {
  $decisionsContent += "当前还没有决策记录。`r`n"
} else {
  foreach ($file in ($decisionFiles | Select-Object -First 20)) {
    $decisionsContent += "- $($file.Name)`r`n"
  }
}
Set-Content -Path (Join-Path $decisionsDir "_index.md") -Value $decisionsContent -Encoding UTF8

Write-Host "Knowledge indexes refreshed." -ForegroundColor Green
