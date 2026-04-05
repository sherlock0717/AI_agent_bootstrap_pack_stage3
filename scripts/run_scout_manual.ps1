param(
  [switch]$DryRun
)

$root = Split-Path -Parent $PSScriptRoot
$config = Join-Path $root "config\tech_watch_sources.yaml"
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$outDir = Join-Path $root "outputs\scout\manual_run\$timestamp"

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

if ($DryRun) {
  python (Join-Path $PSScriptRoot "run_tech_scout.py") --config $config --output-dir $outDir --dry-run
} else {
  python (Join-Path $PSScriptRoot "run_tech_scout.py") --config $config --output-dir $outDir
}

Write-Host "Scout output written to: $outDir" -ForegroundColor Green
