@AGENTS.md

# Claude Entry

## System Positioning

This repository documents and versions the AI Hub operating layer. The live runtime is `D:\AI_Hub`.

## Read First

- System entry: `AGENTS.md`
- Hub architecture: `docs/hub/architecture.md`
- Hub operating model: `docs/hub/operating_model.md`
- Stage 3 migration note: `docs/hub/migration_from_stage3.md`
- Asset boundary: `docs/system/asset_boundary.md`
- Path rules: `docs/system/path_rules.md`

## Working Principles

- Prefer Hub scripts for daily runtime checks: `scripts/check_hub.ps1` and `scripts/start_hub.ps1`.
- Treat `D:\AI_Hub` as runtime state and this repository as versioned control/docs.
- Keep project source code external and register it before using Hub tooling.
- Preserve existing historical deliverables and knowledge unless the user explicitly asks to clean them.
- When changing long-term structure, update README, config, and docs together.

## Directory Awareness

- `config/`: Hub control plane and historical routing configs
- `docs/`: stable explanations and migration notes
- `scripts/`: deterministic entry points
- `knowledge/`: historical/durable notes; new Hub notes should favor Obsidian
- `outputs/`: generated reports
- `projects/`: metadata for external project access