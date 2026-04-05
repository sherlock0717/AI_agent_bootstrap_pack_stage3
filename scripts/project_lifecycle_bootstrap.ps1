param(
  [Parameter(Mandatory=$true)][string]$ProjectId,
  [Parameter(Mandatory=$true)][string]$ProjectName,
  [Parameter(Mandatory=$true)][string]$ExternalRootPath,

  [string]$ProjectType = "pilot_project",
  [string]$ProjectRole = "external_subproject",
  [string]$Owner = "孙海澄",
  [string]$Description = "",
  [string]$Purpose = "作为 AI 系统接入的外部项目",
  [string]$Limitations = "当前阶段以系统接入与流程验证为主。",

  [switch]$CreateBrief,
  [switch]$CreatePlan,
  [switch]$StartFirstWork,

  [string]$BriefTitle = "initial_project_brief",
  [string]$PlanTitle = "initial_project_plan",
  [string]$TaskType = "documentation_planning",
  [string]$Complexity = "medium",
  [string]$SessionTitle = "项目生命周期启动",
  [switch]$NeedRepoContext,

  [switch]$DryRun
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Project Lifecycle Bootstrap ===" -ForegroundColor Cyan
Write-Host "ProjectId        : $ProjectId"
Write-Host "ProjectName      : $ProjectName"
Write-Host "ExternalRootPath : $ExternalRootPath"
Write-Host "ProjectType      : $ProjectType"
Write-Host "ProjectRole      : $ProjectRole"
Write-Host "CreateBrief      : $CreateBrief"
Write-Host "CreatePlan       : $CreatePlan"
Write-Host "StartFirstWork   : $StartFirstWork"
Write-Host "DryRun           : $DryRun"
Write-Host ""

if ($DryRun) {
  Write-Host "[DRY-RUN] Would onboard project." -ForegroundColor Yellow
  Write-Host "[DRY-RUN] Would initialize deliverables directory." -ForegroundColor Yellow

  if ($CreateBrief) {
    Write-Host "[DRY-RUN] Would create deliverable: brief / $BriefTitle" -ForegroundColor Yellow
  }

  if ($CreatePlan) {
    Write-Host "[DRY-RUN] Would create deliverable: plan / $PlanTitle" -ForegroundColor Yellow
  }

  if ($StartFirstWork) {
    Write-Host "[DRY-RUN] Would start first project work session." -ForegroundColor Yellow
  }

  Write-Host ""
  Write-Host "Project lifecycle bootstrap dry-run completed." -ForegroundColor Green
  exit 0
}

# 1. onboarding
& (Join-Path $PSScriptRoot "onboard_project.ps1") `
  -ProjectId $ProjectId `
  -ProjectName $ProjectName `
  -ExternalRootPath $ExternalRootPath `
  -ProjectType $ProjectType `
  -ProjectRole $ProjectRole `
  -Owner $Owner `
  -Description $Description `
  -Purpose $Purpose `
  -Limitations $Limitations

# 2. deliverables init
& (Join-Path $PSScriptRoot "init_project_deliverables.ps1") `
  -ProjectName $ProjectName

# 3. starter deliverables
if ($CreateBrief) {
  & (Join-Path $PSScriptRoot "new_deliverable.ps1") `
    -ProjectName $ProjectName `
    -Type "brief" `
    -Title $BriefTitle
}

if ($CreatePlan) {
  & (Join-Path $PSScriptRoot "new_deliverable.ps1") `
    -ProjectName $ProjectName `
    -Type "plan" `
    -Title $PlanTitle
}

# 4. optional first work cycle
if ($StartFirstWork) {
  & (Join-Path $PSScriptRoot "start_project_work.ps1") `
    -ProjectName $ProjectName `
    -TaskType $TaskType `
    -Complexity $Complexity `
    -SessionTitle $SessionTitle `
    -NeedRepoContext:$NeedRepoContext `
    -CreateProjectNote `
    -ProjectNoteTitle "项目生命周期启动记录"
}

# 5. refresh indexes
& (Join-Path $PSScriptRoot "refresh_knowledge_indexes.ps1")

Write-Host ""
Write-Host "Project lifecycle bootstrap completed." -ForegroundColor Green
