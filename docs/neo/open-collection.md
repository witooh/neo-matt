## What it does

`open-collection` turns `docs/api/*.yaml` into a runnable Bruno OpenCollection: one request `.yml` per endpoint, `environments/`, `folder.yml`, and generated `docs:` per request.

The defining constraint is **self-documenting from the spec**. `docs:` is `yaml2md.py` output (Audience-filtered). K7 fails if it was hand-edited away from that render.

## When to reach for it

Type `/open-collection`, or the agent reaches for it on "สร้าง bruno จาก api spec".

Missing `docs/api/`: stop and author with [api-spec](../../skills/neo/api-spec/SKILL.md) first.

## Prerequisites

PyYAML. Confirm the collection root (`bruno/` by default) before writing.

## Common questions

**Can I import OpenAPI?**

No. Hand-map from the custom YAML. There is no OpenAPI intermediate.

**Why were AC-IDs stripped from `docs:`?**

Audience filter. Bruno docs are for callers, not the owning team's tickets.

## It's working if

- Every endpoint file has a request `.yml` with matching method/path/body example.
- `colcheck.py` exits 0, including K7.
- Secrets in `environments/` are empty + `secret: true`.

## Where it fits

After the contract exists, as a runnable collection. Neighbour: [confluence-api-doc](../../skills/neo/confluence-api-doc/SKILL.md) publishes the same spec. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
