# Token scorecard

Complete this during the 30-minute online lab. Follow `docs/lab-steps.md`. Submit this file using the route in the repository README.

Name: _______________________________  Date: ______________

## Your window

| Reading | Your number |
| --- | --- |
| Tokens in use (`/context`, first line) | |
| System/Tools | |
| Messages | |
| Free space | |
| Buffer | |
| Model Auto used for the one-sentence lookup | |
| Output tokens for that lookup (`/usage`) | |
| Est. tokens, always-on Copilot instructions | |
| Est. tokens, bloated handbook | |
| Est. tokens, `AGENTS.md` | |
| Est. tokens, wiki-style AGENTS file | |
| Est. tokens, release notes Markdown | |
| Est. tokens, release notes HTML | |

## Context audit

| File | Always on, path-scoped, or on demand? |
| --- | --- |
| `.github/copilot-instructions.md` | |
| `AGENTS.md` | |
| `pricing.instructions.md` | |
| `plan-then-execute/SKILL.md` | |

Largest repeated-cost file: _______________________________________________

Why Markdown instead of HTML: _____________________________________________

Why the pricing rule is scoped: ___________________________________________

## The prompt

| Reading | Your number |
| --- | --- |
| Est. tokens, the draft prompt | |
| Est. tokens, my rewrite | |

Tests before: ______ passing / ______ failing

Conflicting comparison found in `src/pricing.js`: _________________________

I used (circle one): zero-token edit / Copilot with my prompt

Tests after: ______ passing / ______ failing

Files changed: ____________________________________________________________

## From the demonstrations

A shared-screen number that surprised me: _________________________________

1. How I will constrain replies: __________________________________________
2. When I will start a new chat: __________________________________________
3. What I will keep stable so caching can work: ____________________________
4. Ask versus Agent: ______________________________________________________

One context item I will stop sending: _____________________________________

One instruction I will move out of always-on context: ______________________

One task I will complete without Copilot: _________________________________
