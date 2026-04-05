param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("bootstrap","start","review","status","deliverables_init","deliverables_list","deliverable_new")]
  [string]$Action,

  [string]$ProjectId = "",
  [string]$ProjectName = "",
  [string]$ExternalRootPath = "",

  [string]$ProjectType = "pilot_project",
  [string]$ProjectRole = "external_subproject",
  [string]$Owner = "孙海澄",
  [string]$Description = "",
  [string]$Purpose = "作为 AI 系统接入的外部项目",
  [string]$Limitations = "当前阶段以系统接入与流程验证为主。",

  [string]$TaskType = "documentation_planning",
  [string]$Complexity = "medium",
  [string]$SessionTitle = "项目工作启动",
  [switch]$NeedRepoContext,
  [switch]$CreateProjectNote,
  [string]$ProjectNoteTitle = "项目工作记录",

  [string]$ReviewTitle = "项目周期复盘",
  [string]$StatusTitle = "项目状态快照",

  [ValidateSet("brief","plan","spec","report","deck_outline","content_script")]
  [string]$DeliverableType = "brief",
  [string]$DeliverableTitle = "new_deliverable",

  [switch]$CreateBrief,
  [switch]$CreatePlan,
  [switch]$StartFirstWork,
  [switch]$DryRun
)

$root = Split-Path -Parent $PSScriptRoot

Write-Host ""
Write-Host "=== Project Ops ===" -ForegroundColor Cyan
Write-Host "Action     : $Action"
if ($ProjectName -ne "") { Write-Host "Project    : $ProjectName" }
Write-Host ""

switch ($Action) {
  "bootstrap" {
    if ([string]::IsNullOrWhiteSpace($ProjectId) -or [string]::IsNullOrWhiteSpace($ProjectName) -or [string]::IsNullOrWhiteSpace($ExternalRootPath)) {
      throw "bootstrap 需要 ProjectId、ProjectName、ExternalRootPath。"
    }

    & (Join-Path $PSScriptRoot "project_lifecycle_bootstrap.ps1") `
      -ProjectId $ProjectId `
      -ProjectName $ProjectName `
      -ExternalRootPath $ExternalRootPath `
      -ProjectType $ProjectType `
      -ProjectRole $ProjectRole `
      -Owner $Owner `
      -Description $Description `
      -Purpose $Purpose `
      -Limitations $Limitations `
      -CreateBrief:$CreateBrief `
      -CreatePlan:$CreatePlan `
      -StartFirstWork:$StartFirstWork `
      -TaskType $TaskType `
      -Complexity $Complexity `
      -SessionTitle $SessionTitle `
      -NeedRepoContext:$NeedRepoContext `
      -DryRun:$DryRun
  }

  "start" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "start 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "start_project_work.ps1") `
      -ProjectName $ProjectName `
      -TaskType $TaskType `
      -Complexity $Complexity `
      -SessionTitle $SessionTitle `
      -NeedRepoContext:$NeedRepoContext `
      -CreateProjectNote:$CreateProjectNote `
      -ProjectNoteTitle $ProjectNoteTitle
  }

  "review" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "review 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "project_review_cycle.ps1") `
      -ProjectName $ProjectName `
      -Title $ReviewTitle `
      -CreateProjectNote:$CreateProjectNote `
      -ProjectNoteTitle $ProjectNoteTitle
  }

  "status" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "status 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "project_status_snapshot.ps1") `
      -ProjectName $ProjectName `
      -Title $StatusTitle
  }

  "deliverables_init" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "deliverables_init 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "init_project_deliverables.ps1") `
      -ProjectName $ProjectName
  }

  "deliverables_list" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "deliverables_list 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "list_project_deliverables.ps1") `
      -ProjectName $ProjectName
  }

  "deliverable_new" {
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
      throw "deliverable_new 需要 ProjectName。"
    }

    & (Join-Path $PSScriptRoot "new_deliverable.ps1") `
      -ProjectName $ProjectName `
      -Type $DeliverableType `
      -Title $DeliverableTitle
  }
}

Write-Host ""
Write-Host "Project ops action completed." -ForegroundColor Green
