## What it does

`api-spec` authors the custom-YAML contract at `docs/api/`. It is the **producer**. `openapi-doc`, `open-collection`, and `confluence-api-doc` only read what it writes.

The defining constraint is **spec-first**: Draft and Generate author from intent (`docs/knowledge/`, the originating ticket/spec, the user's description), not from scanning Go. The one exception is Update-from-code, which syncs routes/fields/types and preserves hand-authored M/O, `business_logic`, `remark`, and `errors`.

## When to reach for it

Type `/api-spec`, or the agent reaches for it when an HTTP endpoint needs a contract.

| What you need | Reach for |
| --- | --- |
| Author or update `docs/api/*.yaml` | `api-spec` |
| A drift report only (no writes) | [openapi-doc](../../skills/engineering/openapi-doc/SKILL.md) |
| Runnable Bruno requests | [open-collection](../../skills/engineering/open-collection/SKILL.md) |
| Confluence pages for callers | [confluence-api-doc](../../skills/engineering/confluence-api-doc/SKILL.md) |

## Prerequisites

PyYAML. Intent must exist (the originating ticket/spec, a knowledge entry, or the user's description). Missing intent: stop; do not invent endpoints.

## Common questions

**Is this OpenAPI?**

No. The YAML carries M/O, Remark, and multi-flow `business_logic` that OpenAPI cannot without `x-` hacks.

**When do I draft vs generate?**

Draft: before code, structural fields only, no `business_logic`. Generate: full author from intent, all three verify layers.

## It's working if

- Each endpoint is one file under `docs/api/<domain>/`.
- `apispeccheck.py` exits 0 and regenerates `index.md`.
- Draft has no `business_logic`; Generate/Update do.

## Where it fits

During `/implement` when the work is HTTP, **before** the handler. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
