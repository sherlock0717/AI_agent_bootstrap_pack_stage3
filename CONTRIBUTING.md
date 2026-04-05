# Contributing

Thanks for contributing to this repository.

## Scope
This repository is the root repository of a reusable AI work system.
It manages:
- rules
- configuration
- scripts
- knowledge structure
- scout workflows
- external project onboarding

It is **not** the place for storing the full codebase of every external project.

## Before making changes
1. Run the system health check:
   .\scripts\run_system_check.ps1
2. Start a session note if the change is part of a focused work session:
   .\scripts\start_system_session.ps1 -Title ""your session title""
3. If the change affects long-term structure, add a system note:
   .\scripts\new_system_note.ps1 -Title ""your note title""

## Change types
Typical contribution types:
- system structure improvements
- rule updates
- script improvements
- knowledge layer improvements
- scout workflow improvements
- onboarding template improvements
- documentation updates

## Preferred workflow
1. Make the smallest useful change
2. Test the related script or workflow
3. Refresh knowledge indexes if needed:
   .\scripts\refresh_knowledge_indexes.ps1
4. Record important decisions
5. Commit with a clear message
6. Push to GitHub

## Commit style
Recommended prefixes:
- feat: new capability
- fix: bug fix
- docs: documentation update
- chore: maintenance or cleanup
- refactor: structure improvement

## Notes
- Deterministic steps should be scripted when possible
- External project code should stay in its own repository
- This root repository mainly stores reusable system assets and management structure
