# Delegate workbook

Course: **Spend less, ship the same — minimizing GitHub Copilot tokens**

The live remote class is 2 hours of demonstration and discussion. Complete one online lab afterwards. It takes about 30 minutes and is self-guided.

Use `delegate/scorecard.md` to record and submit your results.

After you clone this repository, follow [docs/lab-steps.md](../docs/lab-steps.md). That file is the same lab, broken into numbered steps. The machine you need is specified in [docs/image-requirements.md](../docs/image-requirements.md).

Submit: see the root README  
Deadline: see the root README  
Help: see the root README

## Launch the online lab

Preferred route:

1. Clone this repository and run `scripts/prepare-lab.ps1` or `scripts/prepare-lab.sh`.
2. Sign in with the account specified by the course owner (`copilot login`).
3. Open `lab/app` as the workspace folder.
4. In the terminal, run:

   ```powershell
   node --version
   copilot --version
   ```

The hosted workspace should already include Node.js 22 or later, GitHub Copilot CLI, and the course files. Follow the platform sign-in prompt if Copilot is not already authenticated.

If the course owner supplies a downloadable package rather than a hosted workspace, use the local fallback:

```powershell
winget install GitHub.Copilot
copilot login
```

You also need Node.js 22 or later and VS Code with GitHub Copilot. If `copilot` is not found after installation, open a new terminal.

Do not enter personal secrets, customer data, or unrelated source code into the hosted workspace. Save the scorecard before ending the lab; hosted environments may be temporary.

## How you will see tokens

| Meter | Where | What it tells you |
| --- | --- | --- |
| `/context` | Inside Copilot CLI | How full the window is **right now**: instructions, tools, MCP, messages, free space |
| `/usage` | Inside Copilot CLI | Tokens **this session** has consumed. Cache figures appear here when the model reports them |
| Local estimator | `node ../tools/estimate-tokens.mjs` | A rough comparison **before** you spend anything. About 4 characters per token |

Slash commands are typed inside `copilot`, after it is running. `/usage` is a running total, so a new session is how you compare two prompts fairly.

The VS Code Copilot status-bar icon shows this month's quota. [github.com/settings/billing](https://github.com/settings/billing) is the bill. Those update more slowly than `/usage`.

## From the live demonstration

Note one number from the shared screen that surprises you. The habits being shown:

1. **Output.** Code only, and bullets, unless you ask for an explanation. Output tokens are the expensive side of a reply.
2. **Always-on files.** Landmines only. Path rules use `applyTo`. The same fact in two instruction files is paid twice.
3. **Threads.** A new chat when the task changes. `/compact` when the same task is only long.
4. **Cache.** Keep the model, the tools, and the instructions still, and append the next question.
5. **Mode.** Ask or `/ask` for a fact. Agent when the work needs several steps.
6. **Model.** Auto unless you know the task needs more, or less.

---

## Delegate lab — Measure, diagnose, and verify (about 30 minutes)

Complete this once, after the live session. Your evidence is `delegate/scorecard.md`.

Open a terminal in `lab/app`. This is the AndyCorp Lite pricing app. Leave the pricing bug alone until part C. Use the timeboxes to keep moving; exact token figures are not graded.

### A. Measure a real session — 6 minutes

```shell
cd lab/app
copilot
```

Inside Copilot:

```text
/limits set max-ai-credits 30
/instructions
/context
```

`30` is the lowest cap this CLI accepts. A smaller number is rejected.

1. In `/instructions`, confirm that `.github/copilot-instructions.md` is enabled.
2. From `/context`, record tokens in use, System/Tools, Messages, Free space, and Buffer.
3. Run `/model` and leave **Auto** selected.
4. Send exactly one lookup:

   ```text
   In src/format.js, what does formatMoney return? One sentence.
   ```

5. Record the model named on the reply.
6. Run `/usage` and record the output-token total.
7. Run `/exit`.

If Copilot asks to edit a file, decline.

Checkpoint: the reply is one sentence and says that `formatMoney` returns a GBP-formatted currency string.

### B. Audit the context before sending it — 7 minutes

Open these files in the editor:

- `.github/copilot-instructions.md`
- `AGENTS.md`
- `.github/instructions/pricing.instructions.md`
- `.copilot/skills/plan-then-execute/SKILL.md`

For each file, decide whether it is **always on**, **path-scoped**, or **on demand**. Record the four answers on the scorecard.

If `generated/receipt-bundle.js` is missing:

```shell
node ../tools/write-bundle.mjs
```

```shell
node ../tools/estimate-tokens.mjs .github/copilot-instructions.md ../fixtures/copilot-instructions.bloated.md
node ../tools/estimate-tokens.mjs AGENTS.md ../fixtures/AGENTS.wiki.md
node ../tools/estimate-tokens.mjs ../fixtures/release-notes.md ../fixtures/release-notes.html
```

Record the six estimated-token numbers. Then answer:

- Which always-on file would create the largest repeated cost?
- Why should the HTML release notes be converted to Markdown?
- Why does the pricing rule belong in an `applyTo` file rather than the always-on file?

The handbook and HTML notes should dwarf their lean twins. The four release-note sentences are the same in both files.

Do **not** replace `.github/copilot-instructions.md` and do not open `generated/receipt-bundle.js`. You are measuring both without adding them to Copilot’s context.

### C. Diagnose and constrain the task — 8 minutes

From `lab/app`:

```shell
node --test
```

1. Record the number of passing and failing tests.
2. Read `.github/instructions/pricing.instructions.md`.
3. Read `src/pricing.js` and identify the comparison that conflicts with the rule.
4. Do not edit yet.

**Do not send** this draft:

```text
Hey can you look at the whole project and just make the pricing better?
We've had lots of customer complaints and the CEO is unhappy. I'm attaching
our release-notes HTML, the old handbook, and a brain dump of every
architecture principle I can remember. Please refactor everything to classes,
add a database, explain every decision in detail, consider microservices,
keep going until it looks enterprise-ready, and don't stop to ask questions.
```

Save a tighter prompt as `my-prompt.md`. It must:

- Name `src/pricing.js`.
- State that the 10% discount starts at quantity 3.
- Keep discount-before-tax and `TAX_RATE`.
- Forbid test edits, dependencies, and extra files.
- Request a diff-only reply.

Paste the draft into `bad-prompt.md` and compare:

```shell
node ../tools/estimate-tokens.mjs bad-prompt.md my-prompt.md
```

Record both estimates. A strong prompt is precise; it does not need to be the shortest possible prompt.

### D. Implement and prove the result — 7 minutes

Choose one route and record it:

**Zero-token route**

1. Make the one-line comparison change yourself.
2. Save `src/pricing.js`.

**Copilot route**

1. Start `copilot`.
2. Set `/limits set max-ai-credits 30` and leave the model on Auto.
3. Paste the contents of `my-prompt.md` as the prompt.
4. Approve a change only to `src/pricing.js`. Decline test edits, new files, dependencies, or unrelated refactors.
5. Run `/exit`.

For either route, run:

```shell
node --test
```

All three tests must pass. Open `src/pricing.js` and confirm that no other logic changed. Record the final test result and the route you used.

If tests still fail, compare the threshold with the scoped instruction. Do not widen the task or edit the tests.

### E. Submit — 2 minutes

Complete every scorecard field. Write:

- One context item you will stop sending.
- One instruction you would move out of an always-on file.
- One task you would complete without Copilot.

Delete `my-prompt.md` and `bad-prompt.md` when you are finished if you do not want to keep them.

Submit the requested evidence using the route at the top of this workbook. Do not submit secrets, access tokens, customer data, or the full Copilot session transcript.

---

## Take-home card

1. **Output.** Put "Code only, no explanation" and "Bullets over paragraphs" in `.github/copilot-instructions.md`. Say "explain" when you want the prose.
2. **Always-on context.** Landmines only, with no duplicated sentences. Path rules go in `.github/instructions/*.instructions.md` with `applyTo`. Markdown instead of HTML, PDF, or DOCX. Leave generated files closed.
3. **Model.** Auto by default. Reasoning for hard design and debugging. Light models for mechanical edits.
4. **Threads.** New Chat when the task changes. `/compact` when the same task has grown. `/ask` for a side question.
5. **Cache.** Decide model, effort, and tools before the first message. Append after that.
6. **Tools.** Disable MCP servers you are not using. Ask for questions. Agent for multi-step edits.
7. **Fuse.** `/limits set max-ai-credits 30` so a runaway session pauses. This CLI rejects anything below 30.
8. **Check.** `/context` and `/usage` while you work. The billing page for the month.

References:

- [Optimizing your AI usage](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage)
- [Auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection)
- [Managing context in Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/context-management)
- [AI credit session limits](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/set-session-limit)
