param(
    [switch]$SkipCheck,
    [switch]$SkipN8n,
    [switch]$OpenVoice
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$HubRoot = 'D:\AI_Hub'
$RepoCheckScript = Join-Path $PSScriptRoot 'check_hub.ps1'
$RuntimeStartScript = Join-Path $HubRoot 'scripts\start_hub.ps1'
$RuntimeN8nScript = Join-Path $HubRoot 'scripts\start_n8n.ps1'
$RuntimeVoiceScript = Join-Path $HubRoot 'scripts\open_voice_env.ps1'

function Write-Info($Message) { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Ok($Message) { Write-Host "[OK]   $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "[WARN] $Message" -ForegroundColor Yellow }

Write-Host ''
Write-Host '=== AI Hub Repository Start ===' -ForegroundColor Cyan
Write-Host "Repository: $RepoRoot"
Write-Host "Runtime   : $HubRoot"
Write-Host ''

if (-not $SkipCheck) {
    if (Test-Path $RepoCheckScript) {
        Write-Info 'Running repository-to-runtime Hub check.'
        & $RepoCheckScript -SkipDocker
    } else {
        Write-Warn "Check script not found: $RepoCheckScript"
    }
}

if (-not $SkipN8n) {
    if (Test-Path $RuntimeN8nScript) {
        Write-Info 'Starting or opening runtime n8n.'
        & $RuntimeN8nScript
    } elseif (Test-Path $RuntimeStartScript) {
        Write-Info 'Runtime n8n script missing; delegating to runtime start_hub.ps1.'
        & $RuntimeStartScript -SkipCheck
    } else {
        Write-Warn "Runtime start script not found under $HubRoot\scripts"
    }
}

if ($OpenVoice) {
    if (Test-Path $RuntimeVoiceScript) {
        Write-Info 'Opening runtime voice environment.'
        & $RuntimeVoiceScript
    } else {
        Write-Warn "Voice environment script not found: $RuntimeVoiceScript"
    }
}

Write-Host ''
Write-Ok 'Repository Hub start flow finished.'
Write-Host ''
Write-Host 'Useful next commands:' -ForegroundColor White
Write-Host '.\scripts\check_hub.ps1' -ForegroundColor Gray
Write-Host 'D:\AI_Hub\scripts\check_hub.ps1' -ForegroundColor Gray
Write-Host 'D:\AI_Hub\scripts\open_voice_env.ps1' -ForegroundColor Gray