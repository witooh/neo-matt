## What it does

`atlassian` is a thin shell over `acli`: command map, JQL patterns, and safety gates. It does not re-list flags. The installed binary's `--help` is the source of truth.

The defining constraint is **reads are free, writes need a preview**. Bulk `--jql ... --yes` without a search of the same JQL first is a misuse of the skill.

## When to reach for it

Type `/atlassian`, or the agent reaches for it on an ad-hoc Jira/Confluence CLI ask ("ดู issue ของฉัน", "transition ไป In Progress", "search ด้วย JQL").

| What you need | Reach for |
| --- | --- |
| View, search, transition, comment, sprint ops | `atlassian` |
| A card turned into `docs/knowledge/` | [markitdown](../../skills/neo/markitdown/SKILL.md) |
| Generated API docs published to Confluence | `confluence-api-doc` (when that skill is in this repo) |
| GitLab MRs | [gitlab](../../skills/neo/gitlab/SKILL.md) |

## Prerequisites

`acli` on PATH (`brew install atlassian/tap/acli`) and `acli jira auth status` green. Run `acli <path> --help` before any flag you are not sure of.

## Safety

Preview bulk mutations with the same JQL through `search --count` and `search --fields`. Confirm, then mutate. Never expand `tested by` (`issuelinks` type `Tests`) unless the user names those links explicitly.

## Common questions

**Can acli create a Confluence page?**

No. `acli confluence page` is view-only. Page writes go through Confluence REST, or `confluence-api-doc` for the API-doc tree.

**Why not follow "tested by" on the card?**

Those links are test artifacts. This skill treats `type.name == "Tests"` as absent unless the user asks for them by name.

## It's working if

- A read returns keys and summaries from `acli`, not invented tickets.
- A bulk write was previewed (count + keys) and confirmed before `--yes`.
- After a transition or edit, a follow-up `workitem view` shows the change landed.
- `tested by` links are absent from the summary unless the user asked for them.

## Where it fits

A **standalone** CLI skill, off the main flow. Neighbour: [markitdown](../../skills/neo/markitdown/SKILL.md) is ingest, this is live ops. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
