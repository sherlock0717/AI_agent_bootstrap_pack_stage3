---
paths:
  - "scripts/**/*.ps1"
  - "scripts/**/*.py"
---

# Scripts Rules for Claude

- Treat files in scripts/ as execution logic, not as long-form documentation.
- Prefer safe changes with explicit parameters and clear terminal output.
- When adding potentially destructive operations, prefer a dry-run option first.
- Keep script responsibilities clear: execution first, long-term knowledge second.
- If a new script becomes a standard entrypoint, check whether config/system_routes.yaml should be updated.
