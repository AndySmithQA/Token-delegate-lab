# Lab steps

Course: **Spend less, ship the same — minimizing GitHub Copilot tokens**

Time: about 30 minutes after the live session. Work in `lab/app`. Record every result in `delegate/scorecard.md`.

Exact token numbers are not graded. The direction of each comparison is what matters.

Do not paste personal secrets, customer data, or unrelated source code into the lab. Do not submit an access token or a full Copilot transcript.

---

## Before you start

You need the machine described in [image-requirements.md](image-requirements.md):

- Node.js 22 or later
- Git
- VS Code with GitHub Copilot and GitHub Copilot Chat
- GitHub Copilot CLI (`copilot` on PATH)
- A GitHub account with a Copilot licence

Fill in the course owner's submission route, deadline, and help channel from the root README before you begin if they are printed on your joining instructions.

---

## 1. Clone the repository

In PowerShell:

```powershell
git clone <repository-url> token-delegate-lab
cd token-delegate-lab
```

Use the URL the course owner gave you. If the lab portal has already cloned the repository, skip this step and `cd` into that folder.

## 2. Prepare the lab folder

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\prepare-lab.ps1
```

On macOS, Linux, or a Codespace:

```bash
bash scripts/prepare-lab.sh
```

The script checks Node.js, restores the four-line Copilot instructions file if it was overwritten, and creates a Git repository inside `lab/app` so Copilot can see the instruction files. The pricing bug stays in place.

## 3. Confirm the tools

```powershell
node --version
git --version
copilot --version
```

`node --version` must be v22 or higher. If `copilot` is not found, open a new terminal. On Windows the install command is `winget install GitHub.Copilot`. Then open another new terminal and try again.

## 4. Sign in to Copilot

```powershell
copilot login
```

Complete the browser prompt with the account the course owner specified. Stop if you are asked to use a personal account that is not part of the class.

## 5. Open the right folder

Open **`lab/app`** in VS Code. File → Open Folder → select `lab/app`.

Open a terminal in that window. The prompt path must end in `lab\app` (Windows) or `lab/app`.

Do not open the repository root. Fixtures and the estimator sit next to the app so they are not part of the project Copilot is editing.

## 6. Confirm Git is rooted in the app

From the `lab/app` terminal:

```powershell
git rev-parse --show-toplevel
```

The printed path must end in `lab\app` or `lab/app`. If it ends in the clone root, run the prepare script again from the repository root.

## 7. Confirm the starting tests

From `lab/app`:

```powershell
node --test
```

You should see **1 passing** and **2 failing**. The quantity-2 test returns 108 and expects 120. Leave the bug until part C. If all three tests already pass, stop and ask the course owner for a fresh copy. Someone has already fixed `src/pricing.js`.

---

## Part A — Measure a real session (about 6 minutes)

## 8. Start Copilot in the app folder

```powershell
cd lab\app
copilot
```

The commands in steps 9–14 are typed **inside** Copilot, not in PowerShell.

## 9. Set the credit cap

```text
/limits set max-ai-credits 30
```

`30` is the lowest cap this CLI accepts. A smaller number is rejected. The cap pauses a runaway session.

## 10. List loaded instruction files

```text
/instructions
```

Confirm `.github/copilot-instructions.md` is listed and enabled. If the list is empty, type `/exit`, run the prepare script, and start `copilot` again from `lab/app`.

## 11. Read the context window

```text
/context
```

On the scorecard, under **Your window**, write:

- Tokens in use (the first line)
- System/Tools
- Messages
- Free space
- Buffer

Instruction files are inside System/Tools on this CLI. There is no separate Custom Instructions row.

## 12. Leave the model on Auto

```text
/model
```

Select **Auto** if it is not already selected. Do not switch to another model. Auto is the selector. The reply in the next step shows which model it picked.

## 13. Send one lookup

Send exactly this, and nothing else:

```text
In src/format.js, what does formatMoney return? One sentence.
```

If Copilot asks to edit a file, decline.

Checkpoint: the reply is one sentence and says that `formatMoney` returns a GBP-formatted currency string.

On the scorecard, write the **model name printed on the reply**. That is the model Auto selected, not the word Auto itself.

## 14. Read usage and leave

```text
/usage
```

Write the **output-token** total for this session on the scorecard.

```text
/exit
```

`/usage` is a running total. A later comparison needs a new session. You are done with Copilot until part D, and part D is optional.

---

## Part B — Audit the context before sending it (about 7 minutes)

## 15. Classify four files

Open these in the editor. Do not send them to Copilot.

| File | Decide |
| --- | --- |
| `.github/copilot-instructions.md` | Always on, path-scoped, or on demand? |
| `AGENTS.md` | Always on, path-scoped, or on demand? |
| `.github/instructions/pricing.instructions.md` | Always on, path-scoped, or on demand? |
| `.copilot/skills/plan-then-execute/SKILL.md` | Always on, path-scoped, or on demand? |

Write the four answers on the scorecard.

Hints that are part of the files themselves:

- The Copilot file is four lines of output control and is loaded with the project.
- `AGENTS.md` is landmines only. It does not repeat the Copilot file.
- The pricing file has an `applyTo` front matter line.
- The skill is a `SKILL.md` under `.copilot/skills/`. It is not loaded until someone asks for it.

## 16. Create the generated bundle if it is missing

From `lab/app`, only if `generated/receipt-bundle.js` is not there:

```powershell
node ..\tools\write-bundle.mjs
```

Do **not** open `generated/receipt-bundle.js`. It is build output. Opening it or attaching it puts it in context.

## 17. Estimate the three pairs

From `lab/app`:

```powershell
node ..\tools\estimate-tokens.mjs .github\copilot-instructions.md ..\fixtures\copilot-instructions.bloated.md
node ..\tools\estimate-tokens.mjs AGENTS.md ..\fixtures\AGENTS.wiki.md
node ..\tools\estimate-tokens.mjs ..\fixtures\release-notes.md ..\fixtures\release-notes.html
```

The estimator uses about 4 characters per token. It does not call Copilot and does not spend a credit.

Write all six estimated-token numbers on the scorecard:

- always-on Copilot instructions
- bloated handbook
- `AGENTS.md`
- wiki-style AGENTS file
- release notes Markdown
- release notes HTML

## 18. Answer the three audit questions

On the scorecard:

- Which always-on file would create the largest repeated cost?
- Why should the HTML release notes be converted to Markdown?
- Why does the pricing rule belong in an `applyTo` file rather than the always-on file?

The handbook and the HTML notes should be far larger than their lean twins. The four release-note sentences are the same in both release-note files.

Do **not** replace `.github/copilot-instructions.md` with the bloated handbook. Do not start Copilot while that handbook is the always-on file.

---

## Part C — Diagnose and constrain the task (about 8 minutes)

## 19. Run the tests and record them

From `lab/app`:

```powershell
node --test
```

Write passing and failing counts on the scorecard. You want the starting failure, not a fix yet.

## 20. Read the rule and the code

Open:

- `.github/instructions/pricing.instructions.md`
- `src/pricing.js`

Find the comparison in `calculateLineTotal` that conflicts with the discount rule. Write that comparison on the scorecard. Do not edit the file yet.

## 21. Keep the bad prompt out of Copilot

Do **not** send this:

```text
Hey can you look at the whole project and just make the pricing better?
We've had lots of customer complaints and the CEO is unhappy. I'm attaching
our release-notes HTML, the old handbook, and a brain dump of every
architecture principle I can remember. Please refactor everything to classes,
add a database, explain every decision in detail, consider microservices,
keep going until it looks enterprise-ready, and don't stop to ask questions.
```

Save that text as `bad-prompt.md` in `lab/app`. You will only measure it.

## 22. Write a tighter prompt

Save your own prompt as `my-prompt.md` in `lab/app`. It must:

- Name `src/pricing.js`
- State that the 10% discount starts at quantity 3
- Keep discount-before-tax and `TAX_RATE`
- Forbid test edits, dependencies, and extra files
- Request a diff-only reply

A strong prompt is precise. It does not have to be the shortest possible prompt.

## 23. Compare the two prompts

From `lab/app`:

```powershell
node ..\tools\estimate-tokens.mjs bad-prompt.md my-prompt.md
```

Write both estimates on the scorecard.

---

## Part D — Implement and prove the result (about 7 minutes)

Choose one route. Write the route on the scorecard.

## 24a. Zero-token route

1. Make the one comparison change yourself in `src/pricing.js`.
2. Save the file.
3. Do not edit tests, add files, or add dependencies.

## 24b. Copilot route

1. From `lab/app`, start `copilot`.
2. Set `/limits set max-ai-credits 30`.
3. Leave the model on Auto.
4. Paste the contents of `my-prompt.md` as the prompt.
5. Approve a change only to `src/pricing.js`.
6. Decline test edits, new files, dependencies, and unrelated refactors.
7. Run `/exit`.

## 25. Prove the tests

From `lab/app`:

```powershell
node --test
```

All **three** tests must pass. Open `src/pricing.js` and confirm no other logic changed. Write the final pass/fail counts and the files you changed.

If tests still fail, compare the threshold with `.github/instructions/pricing.instructions.md`. Do not widen the task and do not edit the tests.

---

## Part E — Submit (about 2 minutes)

## 26. Finish the scorecard

Complete every field in `delegate/scorecard.md`, including:

- One context item you will stop sending
- One instruction you would move out of an always-on file
- One task you would complete without Copilot

The four lines under **From the demonstrations** are about the live session. If you are doing the lab without having watched it, write what you would do on your own project.

## 27. Remove the prompt drafts if you do not want to keep them

`my-prompt.md` and `bad-prompt.md` are git-ignored. Delete them when you are finished if you do not want them on the machine.

## 28. Submit

Submit `delegate/scorecard.md` by the route on the root README. Do not submit secrets, access tokens, customer data, or the full Copilot session transcript.

---

## If something fails

| What you see | What to do |
| --- | --- |
| `copilot` is not recognised | Open a new terminal. Install with `winget install GitHub.Copilot`, or `npm install -g @github/copilot`. |
| Browser login loops | Run `copilot login` again. Use an account that has a Copilot licence. |
| `/instructions` lists nothing | The Git root is not `lab/app`. From the clone root, run the prepare script, then start `copilot` from `lab/app`. |
| All tests pass at step 7 | `src/pricing.js` was already fixed. Get a fresh clone. |
| The credit cap stops a one-sentence answer | `/exit`, start again, stay on Auto, and keep the cap at 30 unless the course owner tells you to raise it. |
| Copilot edits a test or adds a file | Decline or revert that change. Only `src/pricing.js` should change. |
| You replaced the Copilot instructions with the handbook | From `lab/app`: `Copy-Item ..\fixtures\copilot-instructions.lean.md .github\copilot-instructions.md -Force` then start Copilot again. Do not send a prompt until that restore is done. |
