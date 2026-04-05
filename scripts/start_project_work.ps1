param(
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [string]$TaskType = "code_implementation",
  [string]$Complexity = "medium",
  [string]$SessionTitle = "项目工作启动",
  [switch]$NeedRepoContext,
  [switch]$CreateProjectNote,
  [string]$ProjectNoteTitle = "项目工作记录"
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Start Project Work ===" -ForegroundColor Cyan

& (Join-Path $PSScriptRoot "route_task.ps1") `
  -TaskType $TaskType `
  -ProjectName $ProjectName `
  -Complexity $Complexity `
  -NeedRepoContext:$NeedRepoContext

& (Join-Path $PSScriptRoot "start_project_session.ps1") `
  -ProjectName $ProjectName `
  -Title $SessionTitle

if ($CreateProjectNote) {
  & (Join-Path $PSScriptRoot "new_project_note.ps1") `
    -ProjectName $ProjectName `
    -Title $ProjectNoteTitle
}

Write-Host ""
Write-Host "Project work routine completed." -ForegroundColor Green
