## What it does

`openapi-doc` scans Go and reports where it drifted from `docs/api/`. It **writes nothing**. Reconciliation is `api-spec`.

The defining constraint is **measure, don't edit**. A `DRIFT` line means inspect; a `NOTE` goes to a fresh-eyes pass.

## When to reach for it

Type `/openapi-doc`, or the agent reaches for it on "check go against api-spec" / "หา drift api".

| What you need | Reach for |
| --- | --- |
| Drift report | `openapi-doc` |
| Author or reconcile YAML | [api-spec](../../skills/engineering/api-spec/SKILL.md) |

## Prerequisites

`docs/api/` must exist (`/spec` first if missing). A Go module (`go.mod`). Not a Go repo: stop.

## Common questions

**Does a green script mean the contract is right?**

No. L1 is a tripwire. L2 judges NOTES; L3 catches routes never compared.

## It's working if

- `speccheck.py` is run against `docs/api` and `--src`.
- The report names drift by direction (undocumented route, unimplemented endpoint, field, M/O, type).
- This skill created no YAML files.

## Where it fits

After `/implement` of HTTP work, before Bruno/Confluence. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
