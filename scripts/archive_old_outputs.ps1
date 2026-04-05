param(
  [int]$DaysOld = 7,
  [switch]$DryRun
)

$root = Split-Path -Parent $PSScriptRoot
$outputsRoot = Join-Path $root "outputs"
$archiveRoot = Join-Path $outputsRoot "archive"
$cutoff = (Get-Date).AddDays(-$DaysOld)
$session = Get-Date -Format "yyyy-MM-dd_HHmm"
$archiveSessionDir = Join-Path $archiveRoot $session

New-Item -ItemType Directory -Path $archiveSessionDir -Force | Out-Null

$targets = @(
  (Join-Path $outputsRoot "health"),
  (Join-Path $outputsRoot "scout\manual_run"),
  (Join-Path $outputsRoot "scout\weekly")
)

$moveCount = 0

Write-Host ""
Write-Host "=== Archive Old Outputs ===" -ForegroundColor Cyan
Write-Host "DaysOld cutoff: $DaysOld days"
Write-Host "Cutoff time   : $cutoff"
Write-Host "DryRun        : $DryRun"
Write-Host ""

foreach ($target in $targets) {
  if (!(Test-Path $target)) { continue }

  $items = Get-ChildItem -Path $target -Directory | Where-Object {
    $_.LastWriteTime -lt $cutoff -and $_.Name -ne "archive"
  }

  foreach ($item in $items) {
    $destination = Join-Path $archiveSessionDir $item.Name

    if ($DryRun) {
      Write-Host "[DRY-RUN] Would move: $($item.FullName) -> $destination" -ForegroundColor Yellow
    } else {
      Move-Item -Path $item.FullName -Destination $destination -Force
      Write-Host "Moved: $($item.FullName) -> $destination" -ForegroundColor Green
    }

    $moveCount++
  }
}

if ($moveCount -eq 0) {
  Write-Host "No old output directories matched the archive rule." -ForegroundColor Yellow
} else {
  Write-Host ""
  Write-Host "Processed $moveCount directories." -ForegroundColor Green
}
