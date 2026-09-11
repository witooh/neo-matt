## What it does

`markitdown` ingests one external source into `docs/knowledge/` as a curated, cited entry. It is not a cache: behaviour-constraining clauses are copied verbatim in the source language, with provenance (`source`, `fetched_at`, validator) on every file.

The defining constraint is **one source, one entry, re-readable later**. Status fields and live counters are dropped; the file is the stable facts a later `/to-spec` or `/grill-with-docs` session can cite.

## When to reach for it

Type `/markitdown` or `/ingest`, or the agent reaches for it when a later step needs a citable path that is not in the repo yet.

| What you need | Reach for |
| --- | --- |
| A JIRA card, Confluence page, URL, or file turned into `docs/knowledge/` | `markitdown` |
| Ad-hoc Jira/Confluence CLI (view, transition, search) | [atlassian](../../skills/neo/atlassian/SKILL.md) |
| An interview that builds `CONTEXT.md` | [grill-with-docs](../../skills/engineering/grill-with-docs/SKILL.md) |
| External facts from official docs, not a card | [research](../../skills/engineering/research/SKILL.md) |

## Prerequisites

Writes under `docs/knowledge/` (`contracts/`, `requirements/<domain>/`, `reference/`). JIRA and Confluence ingest go through `atlassian` (`acli` must be installed and authenticated). File conversion uses `uvx markitdown` when the source is PDF/Office/image.

## Curate, don't cache

Buckets locate files; **Related** links carry relationships. A requirements entry that depends on a contract that is not ingested yet must **name** that deferral, never hide it. A silent drop of a conjunct (KB4) is a failed ingest: report BLOCKED, do not ship the entry.

## Common questions

**Can I paraphrase a Thai or English AC into shorter English?**

No, not for behaviour-constraining clauses. Copy them verbatim in the source language. A translation may sit beside the quote, never replace it.

**The card's status will be stale tomorrow. Why ingest it?**

Don't ingest status. Keep title, description, ACs, linked design. Note that status is read live via `atlassian`.

**Do I edit an existing entry when the source changed?**

No. Add a new entry and mark the old one superseded. The validator field is how staleness stays visible.

## It's working if

- One new file exists under the matching `docs/knowledge/` bucket, with `source` and `fetched_at` in frontmatter.
- Behaviour-constraining clauses in the file match the source verbatim.
- `docs/knowledge/INDEX.md` lists the new entry.
- Ephemeral status is absent; a live-read note sits in its place.

## Where it fits

An **on-ramp**. Ingest, then merge onto the main flow at [grill-with-docs](../../skills/engineering/grill-with-docs/SKILL.md) or [to-spec](../../skills/engineering/to-spec/SKILL.md). Neighbour: [atlassian](../../skills/neo/atlassian/SKILL.md) is the CLI, this skill is the durable file. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
