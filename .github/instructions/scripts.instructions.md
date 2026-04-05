---
applyTo: "scripts/**/*.ps1,scripts/**/*.py"
---

Treat files in scripts/ as executable system actions.

Prefer:
- explicit parameters
- safe defaults
- clear terminal output
- dry-run options for archive or move operations
- minimal coupling between execution logic and long-term knowledge storage

If a script becomes a standard system entrypoint, check whether config/system_routes.yaml should be updated.
