## What it does

`confluence-api-doc` publishes `docs/api/*.yaml` to Confluence: one endpoint = one page under domain parents, overview on the parent.

The defining constraint is **caller-facing only**. Ticket framing, evidence paths, and `covers_ac` stay in the repo. An HTTP 200 is not proof; round-trip + fresh-eyes are.

## When to reach for it

Type `/confluence-api-doc` on "publish api doc" / "อัปเดต api doc ไป confluence".

Missing spec: author with [api-spec](../../skills/engineering/api-spec/SKILL.md) first. Ad-hoc Confluence CLI: [atlassian](../../skills/engineering/atlassian/SKILL.md) (view-only for pages).

## Prerequisites

`acli` auth, `CONFLUENCE_API_TOKEN` at push time, a parent-page URL. Never push storage that failed `pubcheck.py` pre-flight.

## Common questions

**Can acli write these pages?**

No. This skill uses REST for writes. `acli` is auth + reads + version.

## It's working if

- Pre-flight exits 0 before any push.
- Round-trip CDATA matches staged storage.
- `covers_ac` and evidence paths are absent from published pages.

## Where it fits

Publish step after the contract exists. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
