# AI System Root Repository

这是我的 AI 工作系统母仓库，用于长期管理可复用的规则、配置、知识层、脚本入口、技术雷达和外部项目接入。

## 当前定位
- 这是系统根目录，不是某个单独项目的代码仓库。
- 真实项目以“外部仓库”形式接入系统。
- 当前第一个接入样板项目是 PsyLens。

## 目录结构
- config/：系统级配置
- scripts/：系统脚本入口
- docs/：系统说明文档
- knowledge/：系统知识层
- projects/：外部项目的接入登记点
- outputs/：运行输出
- logs/：运行日志
- prompts/：可复用提示词
- obsidian_templates/：Obsidian 模板

## 系统原则
- 能脚本化的步骤优先脚本化
- 系统母目录负责管理，不直接承载外部项目真实代码
- 项目通过 project_registry + manifest + local agents 接入
- 重要工作过程进入 sessions / decisions / project notes

## 当前已具备能力
- 系统健康检查
- 外部项目注册
- 系统会话记录
- 决策记录
- 系统级/项目级知识笔记
- 技术雷达手动运行与摘要归档
- 任务路由与项目会话入口

## 常用入口
### 系统健康检查
powershell
cd scripts
.\run_system_check.ps1

### 开始系统会话
powershell
cd scripts
.\start_system_session.ps1 -Title "今天的系统工作"

### 新建系统笔记
powershell
cd scripts
.\new_system_note.ps1 -Title "系统主题"

### 新建项目笔记
powershell
cd scripts
.\new_project_note.ps1 -ProjectName "PsyLens" -Title "项目主题"

### 手动运行技术雷达
powershell
cd scripts
.\run_scout_manual.ps1 -DryRun

### 归档技术雷达摘要
powershell
cd scripts
.\promote_scout_summary.ps1 -Title "技术观察标题"

## 当前外部项目
- PsyLens：系统试运行与方法验证子项目
