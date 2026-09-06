---
name: sync-upstream
description: >
  Project-scope omp maintainer skill for neo-matt. Merge the latest
  mattpocock/skills into this fork and re-apply the fork overlay. Use when
  the user wants to update Matt's skills, sync upstream, merge mattpocock,
  "อัปเดต skill ของ matt", or "ดึงของ Matt". Not part of the shipped plugin.
  Do not use sync-mattpocock (wrong direction, flat layout).
---

# Sync upstream (this repo only)

omp discovers this via `.omp/config.yml` → `skills.customDirectories: [.agents/skills]`.
It is not under `skills/`, not in `.claude-plugin/plugin.json`, and not linked into
`~/.claude/skills`.

You run this. The user does not have to remember the conflict list.

This is a **fork merge**, not a vendor copy. Remote `upstream` is
`git@github.com:mattpocock/skills.git`. Do not import `sync-mattpocock`.
Do not flatten buckets. Do not copy method skills from neo-plugin.

## Preconditions

1. Cwd is this repo (neo-matt). If not, stop.
2. `git remote get-url upstream` must be mattpocock/skills. If the remote is
   missing, add it, do not invent another URL.
3. If the working tree is dirty, stop and report. Do not stash unless the user
   asked.
4. Do not create, switch, or push branches. Merge on the current branch.
5. Do not commit unless the user explicitly asked.

## Merge

```bash
git fetch upstream
git merge upstream/main
```

- Clean merge: go to **Post-merge**.
- Conflicts: resolve per **Conflicts**, then `git add` the resolved files.
  Do not `git merge --abort` unless the user asked.
- If git asks for an editor on the merge message, use the default.

## Conflicts (expected)

Matt-owned skill bodies take **upstream**. Fork-owned paths must survive.

| File | Resolution |
|---|---|
| `CLAUDE.md` | Matt's body (everything above `# Fork overlay (neo-matt)`). Keep the overlay at the bottom. Never take only one side of the whole file. `AGENTS.md` stays a symlink to `CLAUDE.md`. |
| `skills/engineering/code-review/` | Take upstream, then re-apply Collision: code-review from `CLAUDE.md` (spec prefers `docs/tasks/<key>/spec.md`; standards prefer `.kiro/steering/`; Security axis; no-delegation briefs). Re-sync `docs/engineering/code-review.md` if behaviour changed. |
| `skills/engineering/ask-matt/` | Take upstream's map, then restore neo rows: HTTP chain, on-ramps (`markitdown`, `init-project`, `migrate-project`), health (`falsifying`, `bug-hunter`, `attack-test`), standalone (`atlassian`, `gitlab`, `neo-core-sit`, `neo-aux-sit`). Drop a Matt skill that upstream removed. |
| `README.md`, `skills/engineering/README.md`, `skills/productivity/README.md` | Keep neo entries. Add any new Matt promoted skill under the right User-invoked / Model-invoked heading. |
| `.claude-plugin/plugin.json` | Keep neo paths. Add new Matt promoted paths. Copy the same `skills` array into `.grok-plugin/plugin.json`. Do not blindly take Matt's `version` if neo-owned files also changed. |

Fork-owned (ours if git offers a choice, unless the table says otherwise):
`skills/engineering/<neo-name>/`, this overlay, `.omp-plugin/`, `.grok-plugin/`,
`.omp/config.yml`, `.agents/skills/`, `scripts/sync-agent-plugin-layout.sh`,
`skills/<name>` promoted symlinks. Never restore a root `plugin.json`.

Neo names: `falsifying`, `bug-hunter`, `attack-test`, `api-spec`, `e2e-playwright`,
`openapi-doc`, `open-collection`, `confluence-api-doc`, `markitdown`,
`init-project`, `migrate-project`, `atlassian`, `gitlab`, `neo-core-sit`,
`neo-aux-sit`.

## Post-merge

If Matt added, renamed, or removed a **promoted** skill, the Claude `skills` array
and both READMEs already reflect that from Conflicts. Copy that array into
`.grok-plugin/plugin.json`. Then:

```bash
bash scripts/sync-agent-plugin-layout.sh
bash scripts/link-skills.sh
claude plugin validate . --strict
grok plugin validate .
```

Always run the commands after a merge that touched skills or manifests,
even when there were no conflicts.


## Report

Tell the user, in Thai if they wrote Thai:

- merge clean or conflicted (which files)
- whether `code-review` overlay was re-applied
- new / removed Matt skills
- validate result
- uncommitted: they own commit / push
