param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [ValidateSet("idea_text", "file", "folder")]
    [string]$InputMode = "idea_text",

    [string]$IdeaText = "",

    [string]$InputPath = "",

    [string]$Profile = "default",

    [string]$ExternalProjectsRoot = ""
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SystemRoot = Split-Path -Parent $ScriptDir
$DeliverableBriefDir = Join-Path $SystemRoot "deliverables\projects\$ProjectName\brief"
$DeliverablePlanDir = Join-Path $SystemRoot "deliverables\projects\$ProjectName\plan"
$OutputsDir = Join-Path $SystemRoot "outputs\intake\$ProjectName"

Write-Host "== Project Intake Bootstrap ==" -ForegroundColor Cyan
Write-Host "Script dir  : $ScriptDir"
Write-Host "System root : $SystemRoot"
Write-Host "Project name: $ProjectName"
Write-Host "Input mode  : $InputMode"
Write-Host "Profile     : $Profile"

New-Item -ItemType Directory -Force -Path $DeliverableBriefDir | Out-Null
New-Item -ItemType Directory -Force -Path $DeliverablePlanDir | Out-Null
New-Item -ItemType Directory -Force -Path $OutputsDir | Out-Null

if ($InputMode -eq "idea_text") {
    if ([string]::IsNullOrWhiteSpace($IdeaText)) {
        throw "When InputMode=idea_text, -IdeaText is required."
    }

    $IdeaTextPath = Join-Path $OutputsDir "raw_idea_text.txt"
    Set-Content -Path $IdeaTextPath -Value $IdeaText -Encoding UTF8
    $InputPath = $IdeaTextPath
}

if (($InputMode -eq "file" -or $InputMode -eq "folder") -and [string]::IsNullOrWhiteSpace($InputPath)) {
    throw "When InputMode=file or folder, -InputPath is required."
}

$PythonScript = Join-Path $ScriptDir "run_intake_analysis.py"

if (-not (Test-Path $PythonScript)) {
    throw "Missing script: $PythonScript"
}

$PyArgs = @(
    $PythonScript,
    "--system-root", $SystemRoot,
    "--project-name", $ProjectName,
    "--input-mode", $InputMode,
    "--input-path", $InputPath,
    "--profile", $Profile
)

if (-not [string]::IsNullOrWhiteSpace($ExternalProjectsRoot)) {
    $ResolvedExternalProjectDir = Join-Path $ExternalProjectsRoot $ProjectName
    $PyArgs += @("--external-project-dir", $ResolvedExternalProjectDir)
    Write-Host "External project dir (explicit): $ResolvedExternalProjectDir"
}
else {
    Write-Host "External project dir: auto-resolve in Python"
}

& python @PyArgs

if ($LASTEXITCODE -ne 0) {
    throw "run_intake_analysis.py failed with exit code $LASTEXITCODE"
}

Write-Host ""
Write-Host "Intake bootstrap completed." -ForegroundColor Green
Write-Host "Brief output: $DeliverableBriefDir\intake_brief.md"
Write-Host "Plan output : $DeliverablePlanDir\workflow_blueprint.md"
Write-Host "Task file   : see 'Resolved project dir' in terminal output"
