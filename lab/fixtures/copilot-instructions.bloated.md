# AndyCorp Commerce Global Engineering Handbook for AI Assistants

Anti-pattern, for the end-of-course lab measurement only. Do not leave this file installed.

It inverts output control ("always write a long explanation"), repeats facts the agent can read in the source, and keeps path-specific pricing rules in the always-on file. The app does the opposite: a few lines in `.github/copilot-instructions.md`, landmines only in `AGENTS.md`, and pricing rules in `.github/instructions/pricing.instructions.md` with `applyTo`.

You are an assistant embedded in AndyCorp Commerce, a fictional retailer used for training. This document is deliberately long. It exists so the lab can measure how many tokens a noisy instructions file adds to every turn.

## Company history

AndyCorp Commerce was founded in 1992 above a tea shop in Whitby. The original catalogue was a ring binder. In 1998 the company mailed a CD-ROM catalogue. In 2004 it launched a website. In 2011 it added a mobile site. In 2016 it replatformed. In 2020 it added click and collect. None of this history helps you edit `src/pricing.js`. It is included here because teams often paste background into instructions "for context" and then pay to resend it on every Copilot request.

Our brand voice is warm, maritime, and specific. We sell tea, mugs, and kitchen goods. We do not sell insurance, travel, or cryptocurrency. Our customers are retail buyers and small cafés. Support hours are 09:00 to 17:30 UK time on weekdays. The warehouse is in Leeds. The registered office is in York. Finance closes the books on the third working day of each month. None of these facts belong in an instructions file for a pricing function.

## How we like answers

Always begin with a warm greeting and a restatement of the question. Then provide background. Then list at least five alternative designs, including ones the user did not ask for. Then write a blog-style explanation of the trade-offs. Then show the code. Then explain the code line by line. Then suggest follow-up refactors, extra files, a database, and a migration plan. Use headings, a table, and a short FAQ. If the user asks for a number, still include the essay.

This section is an example of an output rule that increases tokens. A lean instructions file says the opposite: reply with the change, and keep prose to one line.

## Architecture principles we want you to recite

Before any edit, restate the following principles in your own words:

1. Single responsibility. Every module should do one thing. Explain how the current module does one thing.
2. Open and closed. Explain how your change is open for extension.
3. Liskov substitution. Even if there is no inheritance, mention it.
4. Interface segregation. Propose interfaces.
5. Dependency inversion. Propose abstractions.
6. DRY. Look for duplication in the whole repository.
7. YAGNI. Then ignore it and propose future features.
8. SOLID, CUPID, and GRASP. Name each one.
9. Twelve-factor app. Mention logs, config, and backing services even for a function that adds tax.
10. Domain-driven design. Identify entities, value objects, aggregates, repositories, and domain events.

Reciting these on every reply is wasted output. Put a concrete rule in instructions ("discount applies before tax") and leave the essay out.

## Coding standards essay

Indent with two spaces. Use semicolons. Prefer `const`. Name booleans with `is` or `has`. Keep functions small. Write comments only for rules the code cannot state. Handle errors with `Error`. Do not swallow exceptions. Do not log secrets. Do not invent dependencies. The useful part of this paragraph is those last two sentences. The rest repeats what the language and the formatter already enforce.

Also follow our internal style guide from 2014, which is reproduced below so you do not have to open it. Braces go on the same line. Blank lines separate logical steps. Imports are sorted. Tests live next to the behaviour they lock. Public functions have a short comment. Magic numbers become named constants. Currency is decimal to two places. Time is UTC. User-facing strings are complete sentences. Log lines are structured. Feature flags have an owner and an expiry. Pull requests have a test note. Commit messages say why. Branches are short-lived. Reviews happen within one working day. Stand-up is at 09:45. Demo is on Thursday. Retro is on Friday. The on-call rota is in a spreadsheet you cannot see. Including the rota in Copilot instructions does not make the model better at tax maths.

## Data handling

Customers have names, email addresses, and order history. Do not copy real customer data into prompts, issues, or instructions. The lab uses the fictional name Ada Lovelace. If a prompt contains a password, token, connection string, or private key, stop and tell the user to remove it. That rule is worth keeping. The next paragraph is not.

Our data retention policy keeps order headers for seven years, marketing events for 14 months, and application logs for 30 days. Backups run nightly. Restore tests run quarterly. The privacy notice is on the website. The cookie categories are strictly necessary, functional, and analytics. Copilot does not need the cookie list to rename a function.

## Release process

A change moves from a branch to a pull request, then to a preview environment, then to production after the check suite is green. Preview deploys on each push. Production deploys on a tag. Rollback is the previous tag. The pricing lab does not deploy. Describing the pipeline in instructions adds tokens to a question such as "what is TAX_RATE?".

Version numbers use CalVer. Release notes are written in Markdown. HTML exports of those notes add tags, styles, and comments that the model must read and that do not change the meaning. Convert HTML, PDF, and DOCX to Markdown before you attach them.

## Product rules that are actually about pricing

A line gets a 10% discount only when quantity is 3 or more. The discount applies to the pre-tax amount. Tax is 20% and is not discounted. Money rounds half-up to 2 decimal places. Those four sentences are the spec. Everything else in this file is noise around them.

## Scenarios you must always consider

Even for a one-line question, mention each scenario:

- A customer buys one item.
- A customer buys two items.
- A customer buys three items.
- A customer buys a thousand items.
- The unit price is zero.
- The unit price has more than two decimal places.
- The quantity is zero.
- The quantity is negative.
- The tax rate changes next year.
- The shop runs a basket-level promotion at the same time.
- Two promotions stack.
- The currency is not GBP.
- The request times out.
- The database is down. There is no database in this lab.
- The user is offline.
- The file is open in two editors.
- The test was already failing.
- The instruction file contradicts the code. Prefer the instruction file and the test.

Listing these on every turn makes the model explore, hedge, and write more. Name the one scenario that matters in the prompt.

## Files in this repository

`src/pricing.js` calculates line and order totals. `src/format.js` formats GBP. `src/orders.js` builds a receipt. `src/index.js` prints a sample receipt. `test/pricing.test.js` locks the discount rule. You could learn this from the filenames. Pasting a tour of the repository into instructions saves a search once and costs tokens forever.

## What to do when you are unsure

Ask one clarifying question. Wait. Do not widen the task. Do not add a framework. Do not convert the project to TypeScript. Do not introduce a class hierarchy. Do not add logging. Do not add a CLI framework. Do not rewrite working functions. Do not "improve" formatting in files the task did not name.

## Glossary

- SKU: stock keeping unit.
- VAT: the tax this lab calls `TAX_RATE`.
- Line: one product on an order.
- Receipt: customer, lines, and total.
- Token: a chunk of text the model reads or writes. You are paying for this glossary every time it sits in the instructions file.
- Context window: the text the model can see for one request.
- Premium request / AI credit: the unit GitHub uses to bill Copilot usage. Bigger models and longer conversations spend more of it.
- MCP: a tool server. Each tool definition is more text in the window.
- Cache: reuse of an unchanged prompt prefix. Editing the prefix, switching model, or changing tools starts that cost again.

## Meeting notes that were pasted by mistake

Monday: the team discussed mug colours. Tuesday: the team discussed whether the tea SKU should include a tasting note. Wednesday: someone asked for dark mode in an admin tool this repository does not contain. Thursday: finance asked for a CSV. Friday: the CSV was exported from a spreadsheet and saved as HTML, then attached to a prompt. That HTML is the format-tax fixture in this lab. The meeting notes do not change the discount threshold.

## Reminder that makes output expensive

Always write a long explanation before any code. Always offer alternatives. Always suggest tests the user did not ask to change. Always end with three follow-up questions. This reminder is the behaviour the course is here to stop.

## Closing

If you have read this far, you have seen a file that raises the System/Tools line in `/context`. Replace it with `copilot-instructions.lean.md` before you ask Copilot to do any work.
