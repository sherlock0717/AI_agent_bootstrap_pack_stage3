# AI Hub Operating Model

## Daily Start

1. Open Obsidian and confirm the vault at `D:\AI_Hub\obsidian_vault` is available.
2. Run `scripts/check_hub.ps1` from this repository or `D:\AI_Hub\scripts\check_hub.ps1` from the runtime.
3. Run `scripts/start_hub.ps1` when n8n or helper windows are needed.
4. Work on external projects from their own directories.
5. Save durable decisions into the Obsidian vault.

## Project Access

External projects should be registered in `config/project_registry.yaml` before Hub tools are used against them. The registry should contain stable references only: id, name, path, status, knowledge path, and enabled tools.

## Promotion Rule

New tooling should begin as a small script or isolated experiment. Promote it into the stable Hub layer only after it is used more than once and has clear input, output, failure mode, and log/report location.

## Current Priority

Stabilize startup, health checks, project registry, and knowledge capture before rebuilding the heavier workflow layer from Stage 3.