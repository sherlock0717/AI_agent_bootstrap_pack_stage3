# AI Hub Architecture

AI Hub is the local capability layer for AI-assisted work. The live runtime is `D:\AI_Hub`; this repository versions the control plane, documentation, and migration notes.

## Runtime Shape

```text
External projects
  -> project registry
  -> Hub scripts
  -> local capabilities
  -> outputs / logs / Obsidian knowledge
```

## Capability Layers

- Knowledge: Obsidian vault under `D:\AI_Hub\obsidian_vault`
- Workflow: n8n under Docker at `http://localhost:5678`
- Browser execution: Playwright MCP, currently oriented around `msedge`
- Voice: faster-whisper and edge-tts under `D:\AI_Hub\voice`
- Code understanding: Graphify and codebase-memory-mcp under `D:\AI_Hub\tools` and `D:\AI_Hub\venvs`

## Repository Role

This repository should hold stable definitions and explanations. It should not hold runtime data, service databases, or external project source trees.

## Asset Boundary

- `config/` controls Hub behavior and records remaining Stage 3 routing.
- `docs/` explains stable decisions.
- `scripts/` executes repeatable tasks or delegates to `D:\AI_Hub\scripts`.
- `outputs/` stores generated reports.
- `logs/` stores repository-local diagnostic traces.
- `knowledge/` preserves historical notes from Stage 3.
- `D:\AI_Hub\obsidian_vault` is the preferred durable Hub knowledge location.