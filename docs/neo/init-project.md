## What it does

`init-project` scaffolds an empty Go hexagonal / DDD service from a frozen template. It serves `GET /health` with **zero business domains**.

The defining constraint is **skeleton only**. First domain is `/implement` (`tdd`), not this skill.

## When to reach for it

Type `/init-project` on "สร้าง service ใหม่" / "scaffold a Go service".

Existing service to restructure: [migrate-project](../../skills/neo/migrate-project/SKILL.md).

## Prerequisites

Go >= 1.26. GOPRIVATE + git credentials for org `common-lib`. Confirm module path, name, id, postgres schema, target dir before generate.

## It's working if

- `initcheck.py` every check PASS.
- `go run ./cmd/api` serves `/health` without Docker.
- No domain/usecase packages yet.

## Where it fits

On-ramp, then main flow at `/implement`. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
