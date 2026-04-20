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