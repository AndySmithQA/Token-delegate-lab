# AndyCorp Lite

Order-pricing demo for the Copilot token course. No dependencies. One pricing test fails until the capstone.

Open **this folder** in VS Code and as the working directory for Copilot CLI. It needs to be a Git repository (`git init` once) or Copilot CLI will not load `.github/copilot-instructions.md`. On this CLI, `/context` counts that file inside System/Tools. `/instructions` lists the loaded files.

| File | When Copilot pays for it |
| --- | --- |
| `.github/copilot-instructions.md` | Every Copilot turn. Output control only: code only, bullets, explain when asked. |
| `AGENTS.md` | Every turn, for tools that read it. Landmines only. It does not repeat the Copilot file. |
| `.github/instructions/pricing.instructions.md` | Only when `src/pricing.js` or `test/pricing.test.js` is in play (`applyTo`). Holds the discount rule. |
| `.github/instructions/receipt.instructions.md` | Only for the receipt and formatting files. |
| `.copilot/skills/plan-then-execute/SKILL.md` | On demand, when that skill is loaded. Not part of the always-on window. |
| `generated/receipt-bundle.js` | Build output. Git-ignored. Do not open it and do not attach it. |

If `generated/receipt-bundle.js` is missing, create it from this folder:

```powershell
node ..\tools\write-bundle.mjs
```

```powershell
node src/index.js
node --test
```

Course steps: `docs/lab-steps.md` in the repository root.
