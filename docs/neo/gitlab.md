## What it does

`gitlab` runs `glab` for MR create/update/read, comments, approve, list, and CI log fetch. It is mechanics only: it does not review the diff and does not fix a red pipeline.

The defining constraint is **glab I/O lives here, judgement lives elsewhere**. A standards/spec review is [code-review](../../skills/engineering/code-review/SKILL.md). A failing job that needs a diagnosis is [diagnosing-bugs](../../skills/engineering/diagnosing-bugs/SKILL.md).

## When to reach for it

Type `/gitlab`, or the agent reaches for it on a GitLab MR URL or "สร้าง MR" / "สรุป MR" / "check pipeline".

| What you need | Reach for |
| --- | --- |
| Create, update, read, list, approve, CI logs | `gitlab` |
| Standards + Spec (+ Security) review of a diff | [code-review](../../skills/engineering/code-review/SKILL.md) |
| A red pipeline you do not understand | [diagnosing-bugs](../../skills/engineering/diagnosing-bugs/SKILL.md) |
| Jira/Confluence CLI | [atlassian](../../skills/neo/atlassian/SKILL.md) |

A bare MR URL with no verb is **MR Read**.

## Prerequisites

`glab` on PATH and `glab auth login` done. Team defaults on every create: `--remove-source-branch` and `--squash-before-merge`.

## Common questions

**Does "review this MR" run here?**

No. Fetch with this skill if you need the diff, then [code-review](../../skills/engineering/code-review/SKILL.md) against a fixed point. Do not spawn review agents inside `gitlab`.

**Can it create an MR?**

Yes. That is a first-class workflow here (verify branch, push, write description, `glab mr create`). It is not gated behind another orchestrator.

## It's working if

- A create prints an MR URL and used the two team-default flags.
- A read is a scannable Thai summary, no comments posted.
- CI inspection prints job names and error excerpts, and does not start a fix.
- An unauthenticated `glab` is reported as `glab auth login`, not as a silent skip.

## Where it fits

A **standalone** CLI skill. Neighbours: [code-review](../../skills/engineering/code-review/SKILL.md) for the review, [diagnosing-bugs](../../skills/engineering/diagnosing-bugs/SKILL.md) for a red pipeline. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
