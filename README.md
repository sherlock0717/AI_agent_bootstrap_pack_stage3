<<<<<<< HEAD
# AI Hub Configuration Repository

This repository is now the versioned configuration, documentation, and migration layer for the local AI Hub runtime at `D:\AI_Hub`.

The previous Stage 3 design treated this as an AI work-system mother repository. That design is still useful as history, but the current center of gravity has moved to AI Hub:

```text
D:\AI_Hub
  -> local capabilities
  -> service startup and health checks
  -> Obsidian knowledge layer
  -> n8n workflow layer
  -> Playwright MCP browser execution
  -> voice tooling
  -> code understanding tools
  -> external project registry
```

## Current Positioning

This repository should be used to version and explain the Hub operating model. It should not become the runtime data directory and should not contain real project source code.

The runtime lives at:

```text
D:\AI_Hub
```

Concrete projects should stay outside the Hub and be registered through `config/project_registry.yaml` before Hub tooling is used against them.

## What This Repository Owns

- Hub architecture documentation
- Hub capability and service configuration
- project registry templates
- migration notes from the old Stage 3 system
- lightweight script entry points that call or check the local Hub
- historical workflow scripts that may be reused later if real usage proves they are needed

## What `D:\AI_Hub` Owns

- installed tools and virtual environments
- Obsidian vault files
- n8n local data
- Playwright logs
- voice environment
- Graphify and codebase-memory-mcp binaries/output
- local health check reports
- backups before external tool configuration writes

## Directory Map

| Path | Current Role |
| --- | --- |
| `config/` | Hub configuration and remaining Stage 3 routing configs |
| `docs/` | stable documentation and migration notes |
| `scripts/` | deterministic entry points; new Hub scripts are preferred for daily use |
| `knowledge/` | historical and durable notes from Stage 3; long-term Hub notes should move toward Obsidian |
| `outputs/` | repository-local generated reports and historical output |
| `logs/` | repository-local logs |
| `projects/` | external project onboarding metadata, not project source code |
| `deliverables/` | historical deliverable layer; not the current Hub priority |
| `templates/` | reusable templates from the previous workflow system |

## Main Hub Entry Points

Use these first:

```powershell
.\scripts\check_hub.ps1
.\scripts\start_hub.ps1
```

The actual runtime scripts are in:

```text
D:\AI_Hub\scripts
```

## Current Migration Policy

Keep from Stage 3:

- asset boundaries
- deterministic scripts
- health checks
- project registry
- durable knowledge capture

Defer from Stage 3:

- heavy deliverable workflow
- start_day / close_day ceremony as default daily flow
- publish snapshot automation
- complex project typing
- GUI dashboards

## Status

- Local runtime baseline: `D:\AI_Hub`
- This repository: Hub configuration and migration layer
- Old sample project PsyLens: historical sample only, not the default Hub project
=======
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
```

## Quick Start

### 1) Go to the scripts directory

```powershell
cd C:\Users\22358\Desktop\系统\AI_agent_bootstrap_pack_stage3\scripts
```

### 2) Run a basic system check

```powershell
.\preflight_check.ps1
```

### 3) Start the day

```powershell
.\start_day.ps1 -SessionTitle "Today system work"
```

### 4) Start work on a project

```powershell
.\project_ops.ps1 -Action "start" -ProjectName "YourProject" -TaskType "documentation_planning" -Complexity "medium" -SessionTitle "Project work start" -NeedRepoContext -CreateProjectNote -ProjectNoteTitle "Project work note"
```

### 5) Create a new project in the external workspace

Run a dry run first:

```powershell
.\create_project_in_workspace.ps1 -ProjectId "demo" -ProjectName "Demo" -CreateBrief -CreatePlan -StartFirstWork -NeedRepoContext -DryRun
```

Then run it for real after checking the result:

```powershell
.\create_project_in_workspace.ps1 -ProjectId "demo" -ProjectName "Demo" -CreateBrief -CreatePlan -StartFirstWork -NeedRepoContext
```

### 6) Check project status

```powershell
.\project_ops.ps1 -Action "status" -ProjectName "YourProject" -StatusTitle "Current project status"
```

### 7) End the day and publish a snapshot

```powershell
.\close_day.ps1 -DecisionTitle "Key decisions today"
.\publish_snapshot.ps1 -Message "chore: update daily system state"
```

For beginners, the three most important entry points are:

- `preflight_check.ps1`
- `start_day.ps1`
- `project_ops.ps1`

---

## A real usage path

Here is what using this system can look like in practice:

**Idea → Project setup → Work session → Deliverables → Knowledge capture → Review**

### 1) Start with a real project idea

You have a concrete project to work on — for example:

- a research tool
- a content workflow
- a portfolio case
- a game community analysis project
- a personal AI-assisted production system

This repository is not meant for abstract planning only.  
It is meant to help you move from an idea to a structured working process.

### 2) Create the project in the external workspace

New real projects should be created in the external workspace first, then connected to the system.

Typical logic:

- **external workspace** = where real projects live
- **system repository** = reusable rules, scripts, notes, workflows, and coordination

This keeps the system reusable while allowing projects to remain independent.

### 3) Start a focused work session

Once the project exists, you use the system to start work in a structured way.

Typical actions include:

- starting a project session
- choosing the task type
- deciding whether repository context is needed
- creating a project note for the current round of work
- keeping execution steps consistent instead of ad hoc

### 4) Produce actual outputs

The goal is not only discussion.  
The goal is to produce reusable outputs.

Typical deliverables include:

- briefs
- plans
- specs
- reports
- deck outlines
- content scripts

This turns AI assistance into visible work products.

### 5) Capture what should be kept

Not every output should become long-term knowledge.

The system separates:

- `outputs/` for temporary execution results
- `knowledge/` for long-term reusable records
- `logs/` for operational traces
- `docs/` for stable human-readable documentation

This prevents useful work from disappearing into scattered chat history.

### 6) Review and continue

At the end of a work cycle, the project can be:

- reviewed
- summarized
- snapshotted
- continued in the next round

That makes the system useful for long-running work, not just one-time tasks.

> Current sample project: **PsyLens**
>
> PsyLens is used as an onboarded sample project to validate the workflow.  
> It is **not** the default project and **not** the center of the system.

---

## Repository map

### Core directories

```text
config/         Control plane and routing
scripts/        Deterministic execution entry points
knowledge/      Long-term reusable knowledge
outputs/        Temporary run outputs and snapshots
logs/           Run logs and troubleshooting traces
docs/           Stable human-readable documentation
projects/       Project onboarding layer
deliverables/   Reusable delivery artifacts
templates/      Reusable templates
schemas/        Config validation schemas
```

### Key boundary

This repository uses a clear asset boundary:

- `outputs/` = temporary results
- `knowledge/` = long-term assets
- `logs/` = execution traces
- `docs/` = stable explanations
- `config/` = system behavior and routing

That boundary is important because it keeps the system usable as it grows.

---

## Key scripts

### System-level

- `preflight_check.ps1`
- `start_day.ps1`
- `run_maintenance_cycle.ps1`
- `weekly_maintenance_cycle.ps1`
- `close_day.ps1`
- `publish_snapshot.ps1`
- `system_release_snapshot.ps1`

### Project-level

- `project_lifecycle_bootstrap.ps1`
- `create_project_in_workspace.ps1`
- `start_project_work.ps1`
- `project_review_cycle.ps1`
- `project_status_snapshot.ps1`
- `project_ops.ps1`

### Deliverables

- `init_project_deliverables.ps1`
- `new_deliverable.ps1`
- `list_project_deliverables.ps1`

### Knowledge and maintenance

- `new_system_note.ps1`
- `new_project_note.ps1`
- `start_system_session.ps1`
- `new_decision_note.ps1`
- `refresh_knowledge_indexes.ps1`
- `promote_scout_summary.ps1`
- `promote_dashboard.ps1`

---

## Current positioning

This repository has already reached a usable **V1 baseline**.

Current strategy:

- use the system to run real projects
- only make small improvements based on actual usage pain points
- avoid expanding the system just for the sake of adding more structure

The main goal is no longer to endlessly design the system itself.

The main goal is to **use the system for real project work**.

---

## System design principles

### 1) Use real projects to drive system evolution

The system should improve from repeated real usage, not from abstract overdesign.

### 2) Keep the core stable

The stable base includes:

- system repo and external project separation
- asset boundary between knowledge, outputs, logs, docs, and config
- project onboarding and project operations
- deliverables layer
- reusable script entry points

### 3) Avoid unnecessary complexity in V1

Not everything needs to become a system feature.

Only repeated and valuable patterns should be promoted into the system layer.

### 4) Make the workflow usable for beginners

Instructions and execution paths should stay as concrete and copyable as possible.

---

## Default model and provider approach

Current V1 default provider strategy:

- primary provider: **DeepSeek API**
- default daily model: `deepseek-chat`
- complex reasoning or debugging: `deepseek-reasoner`

Current integration preference:

- OpenAI-compatible access where possible
- structured JSON outputs when useful
- avoid overcomplicating multi-provider orchestration in V1

---

## Current sample project

### PsyLens

PsyLens is the current onboarded sample project used to validate:

- project onboarding
- local project rules
- project note flow
- deliverables layer
- project review and snapshot flow

Important clarification:

- PsyLens is a **sample project**
- PsyLens is **not** the system itself
- PsyLens is **not** the default future project

New real projects should normally be created in the external workspace first, then onboarded into the system.

---

## Who this repository is for

This repository is especially useful for people who want to:

- use AI across multiple real projects
- keep project execution more structured and repeatable
- separate system infrastructure from project content
- build a reusable personal operating layer for research, content, analysis, or portfolio work
- reduce chaos in multi-round AI collaboration

---

## Recommended usage mindset

Use this repository as:

- a reusable system root
- a stable operations layer
- a place to preserve reusable project knowledge
- a bridge between AI collaboration and concrete deliverables

Do not treat it as:

- a single-project folder
- a one-time experiment
- a place to dump every temporary file without structure

---

## Status

- reusable AI work system baseline established
- Git-managed and connected to GitHub
- external project onboarding workflow available
- project operations entry point available
- deliverables layer available
- sample project already onboarded
- suitable for real project execution

---

## Next step

The best next step is simple:

**Use this system to start and run real projects.**

Let real usage reveal what should be improved next.
>>>>>>> c85153174b8042149bcf1c97ae56ba86c66e2358
