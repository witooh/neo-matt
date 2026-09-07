## What it does

`bug-hunter` hunts product defects no gate asked about. Six grounds, each starting with a command. A candidate is not a finding until a check goes red, green (KILLED), or BLOCKED with evidence.

The defining constraint is **never fix in the hunt**. CONFIRMED rows get reproduce + proposed fix, then `diagnosing-bugs` / `tdd`.

## When to reach for it

Type `/bug-hunter` when a card is green and you want what it still gets wrong.

Not for a reported symptom (`diagnosing-bugs`), a gate audit (`falsifying`), or live HTTP abuse (`attack-test`).

## Common questions

**All ACs pass. Done?**

ACs are the questions someone thought to ask. Ground 1 starts from `docs/knowledge/`, not from the ticket/spec.

## It's working if

- Each ground ran a command, including the ones that found nothing.
- The report is the ledger, CONFIRMED first, each with reproduce + proposed fix.
- Production code was not edited in the hunt.

## Where it fits

Codebase health. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
