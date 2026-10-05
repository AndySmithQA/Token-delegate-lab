# Lab files

Delegates do not start here. Follow [docs/lab-steps.md](../docs/lab-steps.md). The course workbook is [delegate/workbook.md](../delegate/workbook.md).

Open **`app/`** in VS Code and as the working directory for Copilot CLI. Fixtures and the token estimator sit next to it so they are not part of the sample project Copilot is editing.

| Path | Purpose |
| --- | --- |
| `app/` | AndyCorp Lite. Always-on files are output control plus landmines. Path rules use `applyTo`. |
| `app/.github/copilot-instructions.md` | Always-on. "Code only, no explanation." Restore this if the lab replaces it. |
| `app/AGENTS.md` | Always-on landmines. Does not repeat the Copilot file. |
| `app/.github/instructions/` | Scoped instructions. Pricing rules load with pricing files, not on every turn. |
| `app/.copilot/skills/plan-then-execute/` | On-demand skill. Not part of the always-on window. |
| `app/generated/` | Git-ignored build output. Recreate with `node tools/write-bundle.mjs` from `lab/`. |
| `fixtures/copilot-instructions.bloated.md` | Wiki-style always-on file, for the lab contrast |
| `fixtures/copilot-instructions.lean.md` | Copy used to restore the always-on Copilot file |
| `fixtures/AGENTS.wiki.md` | Discoverable facts that do not belong in `AGENTS.md` |
| `fixtures/prompt-precise.txt` and `prompt-vague.txt` | Same task, tighter wording. A small gap next to the instruction files. |
| `fixtures/release-notes.md` | Four sentences |
| `fixtures/release-notes.html` | The same four sentences inside an HTML export |
| `tools/estimate-tokens.mjs` | Local size comparison. About 4 characters per token |
