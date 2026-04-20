# System Maturity

## Current Judgment

The system has moved from a Stage 3 AI work-system mother repository into an AI Hub local runtime model.

The stable runtime baseline is now `D:\AI_Hub`. This repository remains useful as versioned control, documentation, and historical workflow material.

## Stable Core

- Runtime root: `D:\AI_Hub`
- Repository / runtime separation
- External project source code stays outside the Hub by default
- `config/`, `docs/`, `scripts/`, `outputs/`, `logs/`, and knowledge boundaries remain explicit
- Hub capabilities are registered in `config/capabilities.yaml`
- Hub services are registered in `config/services.yaml`
- External projects are registered in `config/project_registry.yaml`
- Main entry points:
  - `scripts/check_hub.ps1`
  - `scripts/start_hub.ps1`
  - `D:\AI_Hub\scripts\check_hub.ps1`
  - `D:\AI_Hub\scripts\start_hub.ps1`

## Guarded Layer

These can change, but updates should be reflected in README, config, and docs together:

- `config/system_routes.yaml`
- `config/project_registry.yaml`
- `config/path_rules.yaml`
- `config/capabilities.yaml`
- `config/services.yaml`
- `scripts/check_hub.ps1`
- `scripts/start_hub.ps1`

## Historical Stage 3 Layer

These remain available but should not be treated as the default Hub path unless real use proves they are needed again:

- deliverables layer
- start_day / close_day workflow
- publish_snapshot automation
- project lifecycle ceremony scripts
- heavy project review and snapshot routines

## Deferred

- complex project typing system
- GUI dashboards
- heavy CI automation
- over-specialized project templates
- binding Hub rules to a single sample project

## Sample Project Note

PsyLens is now a historical Stage 3 sample project. It is not the default AI Hub project.