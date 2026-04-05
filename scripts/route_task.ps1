param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("system_design","code_implementation","debug_refactor","deterministic_task","documentation_planning","project_onboarding","health_check","tech_scout","session_record","decision_record")]
  [string]$TaskType,

  [string]$ProjectName = "",

  [ValidateSet("low","medium","high")]
  [string]$Complexity = "medium",

  [switch]$NeedRepoContext,
  [switch]$Deterministic
)

$preferred = ""
$fallback = ""
$scriptFirst = $false
$description = ""
$notesTarget = ""

switch ($TaskType) {
  "system_design" {
    $preferred = "ChatGPT"
    $fallback = "Claude Code"
    $scriptFirst = $false
    $description = "系统结构、流程规划、规则整理"
    $notesTarget = "knowledge/system"
  }
  "code_implementation" {
    $preferred = "Cursor"
    $fallback = "Copilot"
    $scriptFirst = $false
    $description = "代码实现、脚本修改、文件批量调整"
    $notesTarget = "knowledge/projects/$ProjectName"
  }
  "debug_refactor" {
    $preferred = "Claude Code"
    $fallback = "Cursor"
    $scriptFirst = $false
    $description = "复杂调试、重构、依赖分析"
    $notesTarget = "knowledge/projects/$ProjectName"
  }
  "deterministic_task" {
    $preferred = "Script"
    $fallback = "Cursor"
    $scriptFirst = $true
    $description = "可重复执行、应脚本化的步骤"
    $notesTarget = "knowledge/system"
  }
  "documentation_planning" {
    $preferred = "ChatGPT"
    $fallback = "Cursor"
    $scriptFirst = $false
    $description = "文档规划、方法说明、交付结构"
    $notesTarget = "knowledge/system"
  }
  "project_onboarding" {
    $preferred = "Script"
    $fallback = "ChatGPT"
    $scriptFirst = $true
    $description = "新项目接入、注册、模板复制"
    $notesTarget = "knowledge/system"
  }
  "health_check" {
    $preferred = "Script"
    $fallback = "Cursor"
    $scriptFirst = $true
    $description = "系统或项目健康检查"
    $notesTarget = "knowledge/system"
  }
  "tech_scout" {
    $preferred = "Script"
    $fallback = "ChatGPT"
    $scriptFirst = $true
    $description = "技术雷达、来源监控、更新摘要"
    $notesTarget = "knowledge/system/tech_watch"
  }
  "session_record" {
    $preferred = "Script"
    $fallback = "ChatGPT"
    $scriptFirst = $true
    $description = "工作会话记录"
    $notesTarget = "knowledge/sessions"
  }
  "decision_record" {
    $preferred = "Script"
    $fallback = "ChatGPT"
    $scriptFirst = $true
    $description = "关键决策记录"
    $notesTarget = "knowledge/decisions"
  }
}

Write-Host ""
Write-Host "=== Task Routing Result ===" -ForegroundColor Cyan
Write-Host "TaskType       : $TaskType"
Write-Host "Description    : $description"
Write-Host "Complexity     : $Complexity"
Write-Host "Preferred Tool : $preferred" -ForegroundColor Green
Write-Host "Fallback Tool  : $fallback" -ForegroundColor Yellow
Write-Host "Notes Target   : $notesTarget"
Write-Host "Script First   : $scriptFirst"

if ($NeedRepoContext) {
  Write-Host "Repo Context   : Yes, this task needs project repository context." -ForegroundColor Magenta
}

if ($Deterministic -or $scriptFirst) {
  Write-Host "Recommendation : 优先脚本化，不要只停留在对话中。" -ForegroundColor Green
} else {
  Write-Host "Recommendation : 可先用对话工具澄清，再进入实现。" -ForegroundColor Green
}

if ($ProjectName -ne "") {
  Write-Host "Project        : $ProjectName"
}

Write-Host ""
