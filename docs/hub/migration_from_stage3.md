# Migration From Stage 3

The previous Stage 3 repository was designed as a reusable AI work-system mother repository. That design reached a useful baseline, but the current direction is different: AI Hub is now a local runtime and capability center.

## Keep

- asset boundaries between knowledge, outputs, logs, docs, and config
- deterministic PowerShell entry points
- preflight and health checks
- project registry before project automation
- long-term knowledge capture

## Change

- Replace the old center path with `D:\AI_Hub`.
- Treat this repository as versioned control/docs, not as the runtime state directory.
- Make local capabilities the primary layer: Obsidian, n8n, Playwright MCP, voice, Graphify, and codebase-memory-mcp.
- Keep project source code outside the Hub and outside this repository.

## Defer

- heavy deliverable templates as the default workflow
- start_day and close_day ceremony as the default daily path
- publish snapshot automation
- complex project typing
- GUI dashboards

## Migration Loop

```text
check Hub
  -> start needed services
  -> register project
  -> run targeted tool
  -> write output
  -> preserve durable note
```