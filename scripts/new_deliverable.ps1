param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [Parameter(Mandatory=$true)]
  [ValidateSet("brief","plan","spec","report","deck_outline","content_script")]
  [string]$Type,
  [Parameter(Mandatory=$true)][string]$Title
)

$root = Split-Path -Parent $PSScriptRoot
$projectDir = Join-Path $root ("deliverables\projects\" + $ProjectName)
New-Item -ItemType Directory -Path $projectDir -Force | Out-Null

switch ($Type) {
  "brief"         { $templatePath = Join-Path $root "templates\deliverables\brief.template.md" }
  "plan"          { $templatePath = Join-Path $root "templates\deliverables\plan.template.md" }
  "spec"          { $templatePath = Join-Path $root "templates\deliverables\spec.template.md" }
  "report"        { $templatePath = Join-Path $root "templates\deliverables\report.template.md" }
  "deck_outline"  { $templatePath = Join-Path $root "templates\deliverables\deck_outline.template.md" }
  "content_script"{ $templatePath = Join-Path $root "templates\deliverables\content_script.template.md" }
}

if (!(Test-Path $templatePath)) {
  throw "Template not found: $templatePath"
}

$template = Get-Content -Path $templatePath -Raw -Encoding UTF8
$template = $template.Replace("__TITLE__", $Title)
$template = $template.Replace("__PROJECT_NAME__", $ProjectName)
$template = $template.Replace("__DATE__", (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$safeTitle = ($Title -replace '[\\/:*?"<>| ]','_')
$filePath = Join-Path $projectDir ($timestamp + "-" + $Type + "-" + $safeTitle + ".md")

Set-Content -Path $filePath -Value $template -Encoding UTF8
Write-Host "Created deliverable: $filePath" -ForegroundColor Green
