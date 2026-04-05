# AI System Root Repository

A reusable AI work system for turning ideas into real projects with structured rules, scripts, project onboarding, knowledge capture, and deliverable workflows.

> Build once, reuse across projects.  
> Use AI for real work — not just one-off chats.

## Start here

Choose the path that fits what you want to do:

- **I want to use it now** → go to [Quick Start](#quick-start)
- **I want to understand the system** → read [Why this is different from a normal project template](#why-this-is-different-from-a-normal-project-template)
- **I want to see how it works in practice** → jump to [A real usage path](#a-real-usage-path)

This repository is designed to help you move from loose AI chats to repeatable project workflows.

---

## What this system helps you do

This repository is built for people who want to use AI as a **repeatable work system**, not just as a prompt box.

It helps you:

- start new projects from a stable workflow instead of rebuilding everything from scratch
- keep rules, scripts, notes, decisions, and outputs in a clear structure
- onboard external projects into one reusable operating system
- turn scattered AI collaboration into traceable sessions, deliverables, and project records
- separate temporary outputs from long-term knowledge
- keep project work usable across multiple rounds instead of losing context every time

In short, this is a **system root repository** for running AI-assisted work across different real projects.

---

## Why this is different from a normal project template

A normal project template usually gives you folders and maybe a starter structure.

This repository goes further. It gives you:

- a reusable **system layer** instead of a one-off project scaffold
- a defined split between **system repo** and **external real projects**
- a structured place for **knowledge, outputs, logs, docs, and deliverables**
- reusable **PowerShell entry points** for daily work, project startup, review, and maintenance
- a way to onboard future projects into the same operating model
- a clearer boundary between **temporary execution** and **long-term reusable knowledge**

This means you are not just storing files.  
You are building a working environment that can support repeated AI-assisted project execution.

---

## 30-second workflow

```text
Idea
  ↓
Create project in external workspace
  ↓
Onboard project into the system
  ↓
Start a structured work session
  ↓
Generate deliverables and outputs
  ↓
Capture reusable knowledge
  ↓
Review, snapshot, and continue


## Quick Start

### 1) Go to the scripts directory

```powershell
cd C:\Users\22358\Desktop\系统\AI_agent_bootstrap_pack_stage3\scripts
2) Run a basic system check
.\preflight_check.ps1
3) Start the day
.\start_day.ps1 -SessionTitle "Today system work"
4) Start work on a project
.\project_ops.ps1 -Action "start" -ProjectName "<ProjectName>" -TaskType "documentation_planning" -Complexity "medium" -SessionTitle "Project work start" -NeedRepoContext -CreateProjectNote -ProjectNoteTitle "Project work note"
5) Create a new project in the external workspace

Run a dry run first:

.\create_project_in_workspace.ps1 -ProjectId "demo" -ProjectName "Demo" -CreateBrief -CreatePlan -StartFirstWork -NeedRepoContext -DryRun

Then run it for real after checking the result:

.\create_project_in_workspace.ps1 -ProjectId "demo" -ProjectName "Demo" -CreateBrief -CreatePlan -StartFirstWork -NeedRepoContext
6) Check project status
.\project_ops.ps1 -Action "status" -ProjectName "<ProjectName>" -StatusTitle "Current project status"
7) End the day and publish a snapshot
.\close_day.ps1 -DecisionTitle "Key decisions today"
.\publish_snapshot.ps1 -Message "chore: update daily system state"

For beginners, the three most important entry points are:

preflight_check.ps1
start_day.ps1
project_ops.ps1
