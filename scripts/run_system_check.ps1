param()

$root = Split-Path -Parent $PSScriptRoot
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$outDir = Join-Path $root "outputs\health\$timestamp"

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

python (Join-Path $PSScriptRoot "check_system_health.py") `
  --root $root `
  --output-json (Join-Path $outDir "system_health.json") `
  --output-md (Join-Path $outDir "system_health.md")

Write-Host "System health written to: $outDir" -ForegroundColor Green
