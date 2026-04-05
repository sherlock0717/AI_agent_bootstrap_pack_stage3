# AI System Root Repository — README 首页改版稿

## 1) GitHub About 文案（可直接替换）

### 推荐版（最稳）
A reusable AI work system for turning ideas into real projects with structured rules, scripts, project onboarding, knowledge capture, and deliverable workflows.

### 更偏产品展示版
An AI work system for planning, starting, running, and reviewing real projects — with reusable rules, scriptable workflows, project onboarding, and built-in knowledge capture.

### 更偏个人能力展示版
A production-oriented AI workflow system that helps turn messy tasks into reusable project flows, documented decisions, and concrete deliverables.

---

## 2) README 首页结构建议

建议首页改成下面 8 个区块：

1. Hero：一句话定位 + 3 个价值点
2. Why this repo exists
3. 30-second workflow
4. What makes it different
5. Quick Start
6. Real project example
7. Repository map
8. Current status / next step

重点不是把信息写得更多，而是把“首次访问者的理解顺序”写对：

- 先知道这是干什么的
- 再知道为什么和普通模板不同
- 再知道如何开始
- 最后再去看目录和细节

---

## 3) README 完整改版稿（可直接替换）

```md
# AI System Root Repository

A reusable AI work system for turning ideas into real projects with structured rules, scripts, project onboarding, knowledge capture, and deliverable workflows.

> Build once, reuse across projects.
> Use AI for real work — not just one-off chats.

## What this system helps you do

This repository is designed for people who want to use AI as a **repeatable work system**, not just as a single prompt tool.

It helps you:
- start new projects from a stable workflow instead of rebuilding everything from scratch
- keep rules, scripts, notes, decisions, and outputs in a clear structure
- onboard external projects into one reusable operating system
- turn messy AI collaboration into traceable sessions, deliverables, and project records

## Who this is for

This system is especially useful if you want to:
- run multiple AI-assisted projects over time
- keep long-term knowledge instead of losing context in chats
- standardize how projects are started, reviewed, and documented
- combine scripting, project structure, and agent rules into one working setup

## Why this is different from a normal project template

Most templates give you a folder structure.
This system gives you an **operating layer** for real work.

It combines:
- **rules** for how different AI tools should behave
- **scripts** for repeatable actions and project lifecycle tasks
- **knowledge capture** for sessions, decisions, reviews, and reusable notes
- **project onboarding** so real external projects can plug into the system
- **deliverable workflows** so work ends as briefs, plans, reports, specs, or deck outlines

In short: this repo is not just a template for storing files.
It is a reusable workflow system for managing AI-assisted project work.

## 30-second workflow

```text
Idea / task
  -> create or onboard project
  -> start project work through script entry points
  -> use AI tools under shared rules
  -> capture notes / sessions / decisions
  -> generate deliverables
  -> review, snapshot, and reuse the system again
```

## Quick Start

### 1. Go to the scripts folder

```powershell
cd C:\Users\22358\Desktop\系统\AI_agent_bootstrap_pack_stage3\scripts
```

### 2. Run the system preflight check

```powershell
.\preflight_check.ps1
```

### 3. Start the day

```powershell
.\start_day.ps1 -SessionTitle "今天的系统工作"
```

### 4. Start work on a project

```powershell
.\project_ops.ps1 -Action "start" -ProjectName "<ProjectName>" -TaskType "documentation_planning" -Complexity "medium" -SessionTitle "项目工作启动" -NeedRepoContext -CreateProjectNote -ProjectNoteTitle "项目工作记录"
```

### 5. Create a new project in the default workspace

```powershell
.\create_project_in_workspace.ps1 -ProjectId "demo" -ProjectName "Demo" -CreateBrief -CreatePlan -StartFirstWork -NeedRepoContext -DryRun
```

After checking the dry run result, remove `-DryRun` to execute it for real.

## A real usage path

Example: you want to start a new IP / content / product idea.

You can use this system to:
1. create the new project in the default external workspace
2. register it into the system
3. start a project session with shared rules and context
4. generate a brief and an initial plan
5. save key decisions and reusable notes
6. review the project status later without rebuilding the context from zero

That means the system is useful not only for coding projects, but also for:
- research and analysis projects
- content planning projects
- product and workflow design projects
- portfolio or case-study style projects

## Repository map

- `config/` — control plane and system-level configuration
- `scripts/` — repeatable script entry points
- `docs/` — stable system documentation
- `knowledge/` — long-term reusable knowledge
- `projects/` — external project registration layer
- `deliverables/` — project deliverables by type
- `outputs/` — temporary outputs and snapshots
- `logs/` — runtime logs
- `prompts/` — reusable prompts
- `templates/` — reusable project and deliverable templates

## Current positioning

- This is the **system root repository**, not a single standalone project repo.
- Real work projects are expected to live as **external projects** and connect into this system.
- `PsyLens` is the current **sample onboarded project**, used to validate the workflow.
- New real projects should be created from the default external workspace first, then onboarded into the system.

## Core system layers

This repository currently works across six layers:
- Knowledge Layer
- Protocol Layer
- Execution Layer
- Deterministic Script Layer
- Scout Layer
- Product / Deliverables Layer

## Current status

The system has already reached a usable V1 baseline for real project work.
The current priority is:

> use the system for real projects first, and only expand it when repeated real-world pain points appear.

## Key document

For the current V1 boundary, workspace defaults, usage rules, and stable operating assumptions, see:

- `docs/system/v1_freeze_guide.md`

## Topics

`ai-workflow` `workflow-automation` `knowledge-management` `project-onboarding` `developer-tooling` `agent-rules` `research-workflow` `powershell`
```

---

## 4) 首页最该优先修的 5 个点

### 1. 开头第一句要从“仓库是什么”改成“它能帮人做什么”
你现在的开头是管理视角，缺的是用户收益视角。

### 2. README 前 屏不要先讲目录，要先讲路径
目录是证明系统存在，路径才是让人愿意继续看。

### 3. Quick Start 必须和你当前 V1 口径完全统一
建议首页只保留这几个主入口：
- `preflight_check.ps1`
- `start_day.ps1`
- `project_ops.ps1`
- `create_project_in_workspace.ps1`

### 4. PsyLens 要保留，但只能作为 sample project
不要让陌生人误以为这个仓库是在服务一个特定项目。

### 5. 首页要加“Why this is different”
因为你这个仓库最大的价值不只是结构整齐，而是：
它把规则、脚本、知识沉淀、项目接入、交付物流程放进了同一个系统里。

---

## 5) 建议同时修改的 Topics

当前 topics 可以更偏“别人会搜什么”，建议改成：

- ai-workflow
- workflow-automation
- knowledge-management
- developer-tooling
- project-onboarding
- agent-rules
- powershell
- project-ops
- research-workflow
- ai-system

如果只能保留少量，就优先：
`ai-workflow` `workflow-automation` `knowledge-management` `developer-tooling` `project-onboarding`

---

## 6) 建议的下一步

最优顺序：
1. 先改 About
2. 再整块替换 README 首页前半部分
3. 然后统一 Quick Start 命令口径
4. 最后再补一张简单的 workflow 图

workflow 图不用复杂，第一版甚至可以先用 README 里的文本流程图顶住。
