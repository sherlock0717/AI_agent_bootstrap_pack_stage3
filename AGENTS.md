# AGENTS.md

## Repository Positioning

This repository is now the versioned configuration and documentation layer for the local AI Hub runtime at `D:\AI_Hub`.

It is not a single project repository and it is no longer the main runtime directory. The runtime state, installed tools, service data, and generated local reports belong in `D:\AI_Hub`.

## Current Hub Runtime

- Hub root: `D:\AI_Hub`
- Knowledge layer: `D:\AI_Hub\obsidian_vault`
- Workflow layer: n8n at `http://localhost:5678`
- Browser execution: Playwright MCP with logs under `D:\AI_Hub\logs\playwright`
- Voice layer: `D:\AI_Hub\voice`
- Code understanding: Graphify and codebase-memory-mcp under `D:\AI_Hub\tools` and `D:\AI_Hub\venvs`

## Basic Principles

1. Keep real project source code outside both this repository and `D:\AI_Hub` unless it is an explicit experiment.
2. Register external projects in `config/project_registry.yaml` before running Hub tooling against them.
3. Put temporary generated artifacts in `outputs/` or the Hub runtime `outputs/` directory.
4. Put durable Hub decisions and notes into the Obsidian vault.
5. Do not store API keys, cookies, account data, or private credentials in this repository.
6. New automation must state its input, output, failure behavior, and log/report location.

## Current Priorities

- First priority: stabilize the AI Hub runtime interface around `D:\AI_Hub`.
- Second priority: keep config and docs synchronized with the runtime.
- Third priority: register real external projects cleanly.
- Fourth priority: only promote old Stage 3 workflows after repeated real use.

## Do Not

- Do not turn this repository back into a single-project workspace.
- Do not let PsyLens, DreamEcho, or any other project define global Hub rules.
- Do not copy external project source trees into this repository by default.
- Do not overwrite existing project deliverables or historical notes during Hub migration.