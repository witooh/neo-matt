## What it does

`e2e-playwright` authors and **runs** HTTP e2e tests, one per acceptance criterion, on a Jest + Playwright-`request` harness (no browser). Titles are `[<CARD> - AC-NNN] <desc> → <expected>`.

The defining constraint is **the suite is the HTTP acceptance gate**. A green unit test cannot stand in for it. Non-HTTP ACs are `it.skip` with a reason in the title, never a silent drop.

## When to reach for it

Type `/e2e-playwright` on "write e2e" / "รัน e2e" / "e2e ตาม AC".

| What you need | Reach for |
| --- | --- |
| HTTP AC tests | `e2e-playwright` |
| Unit / logic tests | [tdd](../../skills/engineering/tdd/SKILL.md) |
| Wire contract | [api-spec](../../skills/engineering/api-spec/SKILL.md) |

## Prerequisites

An existing `tests/e2e` Jest+Playwright harness. If missing: report and stop; do not invent one. ACs from `docs/tasks/<card>/spec.md` or legacy `docs/design/`. No AC section: no-AC mode (coverage N/A).

## Common questions

**Jest or `@playwright/test`?**

Jest `it()`. Playwright is only the HTTP client.

**No ACs on the card?**

Do not invent them. Title `[<CARD>] …` and assert the api-spec endpoints.

## It's working if

- Every HTTP-observable AC has an `it()` (or a justified skip / `Deferred-ACs:`).
- `e2echeck.py` exits 0 when ACs exist.
- The run artifact is a real `npm test` transcript, not a claim.

## Where it fits

After `/implement` of HTTP-observable ACs. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
