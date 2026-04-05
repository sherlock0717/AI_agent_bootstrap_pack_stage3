# Data pipeline path-specific instructions

Apply these instructions to files under:
- scripts/
- config/
- prompts/
- schemas/

## Rules
- Never silently change CSV column names used downstream.
- Keep input and output file arguments explicit.
- Add failure logging for network or parse errors.
- Prefer deterministic preprocessing in Python over AI-based cleaning when possible.
- AI-generated labels must remain clearly separated from manual labels.
- Any new JSONL output should contain stable IDs.
