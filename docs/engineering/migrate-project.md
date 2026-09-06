## What it does

`migrate-project` restructures an **existing** Go service to the same hexagonal blueprint `init-project` ships, slice by slice, behavior-preserving (`git mv` + verify).

The defining constraint is **orchestrate, never move code yourself**. Specialists migrate; you plan and checkpoint.

## When to reach for it

Type `/migrate-project` on "refactor ให้เหมือน account-service". Empty dir: [init-project](../../skills/engineering/init-project/SKILL.md). New domain after migrate: `/implement`.

## Prerequisites

A Go codebase. Plan lives at `<target>/docs/migration/plan.md` (resumable). CP1 (plan approval) before any move.

## It's working if

- Each slice is green (`go test` / vet / lint) before `done`.
- `structurecheck.py` plus a Docker image build pass at the end.
- No auto-merge or push.

## Where it fits

On-ramp. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
