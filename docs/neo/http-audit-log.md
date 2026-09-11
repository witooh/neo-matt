## What it does

`http-audit-log` ports **one-row** HTTP audit logging onto a Go hexagonal gin+sqlc service: one `audit_log` row per inbound request, SUCCESS and FAILED, written by the outermost gin middleware after the handler returns and before the client sees the response.

Persistence is fail-soft. A database error is logged; the request still succeeds. The schema and middleware match account-service MR 196, not a new design.

## When to reach for it

Type `/http-audit-log`, or the agent reaches for it on "เพิ่ม audit log" / "add audit log" / "audit_log table".

| What you need | Reach for |
| --- | --- |
| Per-request HTTP `audit_log` | `http-audit-log` |
| `created_by` / `updated_by` actor strings | not this skill |
| HTTP AC tests | [e2e-playwright](../../skills/neo/e2e-playwright/SKILL.md) |
| Empty Go skeleton | [init-project](../../skills/neo/init-project/SKILL.md) |

## Prerequisites

A Go hexagonal service with gin, sqlc, and postgres migrations (account-service / `init-project` layout). Without that layout: the skill stops.

## one-row

Every inbound HTTP call, including `/health`, becomes one row. The middleware is registered first so it wraps the whole chain. Tests may pass a `nil` repository (no-op persist). Searchable `metadata` stays `{}` until you name keys.

## Common questions

**Does this also change `created_by` / `updated_by`?**

No. Account-service shipped that in the same MR as a mobile actor format. This skill only adds HTTP `audit_log`.

**Does `/health` get a row?**

Yes. Cleanup SQL should `TRUNCATE` the table so e2e runs do not grow it without bound.

**What if persist fails?**

The request still returns its original status. The middleware logs and moves on.

## It's working if

- `auditcheck.py` prints `PASS: 0 error(s)`.
- A 2xx probe writes `status = SUCCESS`; a 4xx probe writes `FAILED` with that `http_status`.
- Passing `nil` as the audit repo does not panic handler tests.

## Where it fits

During / after `/implement` on HTTP services, next to the api-doc chain, not a second main flow. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
