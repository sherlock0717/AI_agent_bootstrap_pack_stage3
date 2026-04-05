# GitHub Copilot Repository Instructions

## Repository purpose
This repository is an AI-assisted research workflow project. It turns raw feedback into structured evidence, theme tags, psych hypotheses, and business-facing outputs.

## How to help
- Prefer incremental edits over big rewrites.
- Preserve current file paths and CLI argument style.
- Keep scripts reusable and parameterized.
- When adding code, include comments only where they add clarity.
- If a scraper fails, preserve logs and debug HTML rather than hiding the failure.

## Validation
Before suggesting completion:
- confirm the script still accepts command-line args
- confirm output paths are explicit
- confirm field names remain stable
- confirm any new dependency is necessary

## Output style
When proposing code changes:
- explain what changed
- explain why it changed
- mention any side effects on downstream scripts
