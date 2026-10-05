---
name: plan-then-execute
description: Use when the approach is not known yet or the change spans several files. Skip when the edit is one known line.
---

On-demand skill. It is not always-on context. Load it only for a multi-step change.

1. This session: write the approach to `plan.md`. Change no product code. Stop.
2. New session: implement only `plan.md`. Stay on Auto. Code only.
3. Run `node --test`.

One known line, such as the quantity check in `src/pricing.js`: type it. Do not load this skill.
