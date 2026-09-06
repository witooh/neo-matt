## What it does

`falsifying` attacks a green signal to see whether it can go red. Scope is the **apparatus** (gate, checker, coverage number, CI job), not the product.

The defining constraint is **construct the case that must fail**. "I reviewed it" is not a result.

## When to reach for it

Type `/falsifying`, or the agent reaches for it when a gate was written/changed, or a metric looks better than the work.

| Job | Reach for |
| --- | --- |
| Can this gate go red? | `falsifying` |
| Latent product defects | [bug-hunter](../../skills/engineering/bug-hunter/SKILL.md) |
| Live HTTP abuse | [attack-test](../../skills/engineering/attack-test/SKILL.md) |
| A reported bug | [diagnosing-bugs](../../skills/engineering/diagnosing-bugs/SKILL.md) |

## Common questions

**The suite is green. Why run this?**

Green only proves the suite passed. This asks whether it *could* fail.

## It's working if

- You have a counter-case with an exit code, or a source-disagreement table.
- A confirmed finding is handed to `diagnosing-bugs` / `tdd`, not patched in place.

## Where it fits

Codebase health, already green. Neighbour of [improve-codebase-architecture](../../skills/engineering/improve-codebase-architecture/SKILL.md), different target. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
