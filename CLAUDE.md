Skills are organized into bucket folders under `skills/`:

- `engineering/`: daily code work
- `productivity/`: daily non-code workflow tools
- `misc/`: kept around but rarely used, not promoted
- `in-progress/`: beta: public on purpose, feedback wanted, not shipped in the plugin
- `deprecated/`: no longer used

Every skill in `engineering/` or `productivity/` (the **promoted** buckets) must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`'s `skills` array (the Claude Code plugin ships exactly the promoted set). Skills in `misc/`, `in-progress/`, and `deprecated/` must not appear in either.

Install commands are copied verbatim from [.agents/install-block.md](./.agents/install-block.md). `.claude-plugin/marketplace.json` makes the repo its own single-plugin marketplace (a fallback the install block explains, not the documented route). Run `claude plugin validate . --strict` after touching either manifest. Why a Claude plugin but not (yet) a Codex one lives in [.agents/adr/0002-ship-as-a-claude-code-plugin.md](./.agents/adr/0002-ship-as-a-claude-code-plugin.md).

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`. The promoted buckets' `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**; non-promoted bucket `README.md`s (`misc/`, `in-progress/`) use a flat list.

Skills in `engineering/` and `productivity/` also have a human-facing docs page at `docs/<bucket>/<skill-name>.md` (the docs tree mirrors those two bucket folders under `skills/`). The published URL is `https://aihero.dev/skills-<skill-name>` regardless of bucket: the docs path is repo organisation only. When you add, rename, or change the behaviour of a skill in `engineering/` or `productivity/`, create or re-sync its docs page following [.agents/writing-docs.md](./.agents/writing-docs.md). A finished page carries four sections: **What it does**, **When to reach for it**, **Common questions**, and **It's working if**. `writing-docs.md` holds the template, the section order, and where to hunt for the questions. Skills in the non-promoted buckets (`misc/`, `in-progress/`, `deprecated/`) get **no** docs page.

Every `SKILL.md` is either user-invoked (`disable-model-invocation: true` plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`, reachable only by the human) or model-invoked (model- or user-reachable). See [.agents/invocation.md](./.agents/invocation.md).

[`ask-matt`](./skills/engineering/ask-matt/SKILL.md) is the router that maps every user-reachable skill and how they relate. The same trigger that re-syncs a docs page applies to it: whenever you add, rename, remove, or change how a user-reachable skill fits the flows, re-read `ask-matt`'s `SKILL.md` and update it so the map stays accurate: a new skill it never mentions, or a stale one it still routes to, is a router that lies.

To (re)link every skill outside `deprecated/` and `misc/` into the local harness skill directories (`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each entry is a symlink into this repo, so a `git pull` keeps installed skills current; re-run the script after adding, removing, or renaming a skill.

No em-dashes anywhere in this repo's prose (`SKILL.md` files, docs, `README.md`, `CHANGELOG.md`, ADRs, changesets, code comments). Where a sentence reaches for one, rewrite it instead with a comma, colon, period, parentheses, or a conjunction, whichever the sentence actually wants; never do a blind character substitution.

# Fork overlay (neo-matt)

This repo is a fork of [mattpocock/skills](https://github.com/mattpocock/skills). The body above is upstream's rules and stays the merge surface. This section is fork-owned.

**Process is Matt's.** The router is [`ask-matt`](./skills/engineering/ask-matt/SKILL.md). Work travels `grill-with-docs` → `to-spec` / `to-tickets` → `implement` (`tdd` then `code-review`). Do not import `using-neo` as an orchestrator, do not inject it at session start, and do not land neo graph nodes (`neo-builder`, `neo-author`, `neo-e2e`, `fresh-eyes`) or neo `hooks/` / `extensions/`.

**Neo adds domain skills, not a second main flow.** They live under `skills/engineering/<name>/` like every other engineering skill. No `skills/neo/` bucket. Default invocation is model-invoked so `/implement` can reach them. `ask-matt` must name every one (on-ramp, health, or standalone). A neo skill it never mentions is a router that lies.

Do not copy method skills from neo-plugin. They are already here: `tdd`, `diagnosing-bugs`, `research`, `prototype`, `domain-modeling`, `codebase-design`, `resolving-merge-conflicts`, `grilling`.

## Neo-owned skills to land

`falsifying`, `bug-hunter`, `attack-test`, `api-spec`, `e2e-playwright`, `openapi-doc`, `open-collection`, `confluence-api-doc`, `markitdown`, `init-project`, `migrate-project`, `atlassian`, `gitlab`, `neo-core-sit`, `neo-aux-sit`.

Where they sit on the `ask-matt` map:

- **On-ramps:** ingest a source → `markitdown`; new Go service → `init-project`; restructure a Go service → `migrate-project`. Then merge onto the main flow.
- **During / after `/implement` (HTTP):** author `docs/api/` with `api-spec` before the handler; `openapi-doc` for drift; `open-collection` / `confluence-api-doc` as publish steps; HTTP-observable ACs → `e2e-playwright`.
- **Codebase health (already green):** `falsifying` (the gate), `bug-hunter` (the product), `attack-test` (live HTTP). Same neighbourhood as `improve-codebase-architecture`, different target.
- **Standalone:** `atlassian`, `gitlab`, `neo-core-sit`, `neo-aux-sit`.

When an imported `SKILL.md` says "when `using-neo` routes here", rewrite that trigger to the row above. Do not leave a pointer at an orchestrator this fork does not ship.

## Collision: code-review

One skill. Keep Matt's file. Port neo's source-discovery on top: spec prefers `docs/tasks/<key>/spec.md` when present, else Matt's issue-tracker lookup; standards prefer `.kiro/steering/` when present, else `CODING_STANDARDS.md` / `CONTRIBUTING.md`. Keep the Fowler smell baseline. Keep neo's optional Security axis (untrusted input, auth, secrets, money, PII).

## Landing a neo skill

Copying `SKILL.md` is not enough:

1. `skills/engineering/<name>/` including `assets/` and `references/`.
2. `agents/openai.yaml` (Codex metadata; `policy.allow_implicit_invocation: false` only if user-invoked).
3. Rewrite every em-dash in the imported prose. No blind character substitution. Neo-plugin prose is full of them.
4. Skill-tool calls stay name-based. Strip `using-neo` / graph-node / `docs/tasks/<key>/` orchestrator assumptions unless the skill still needs that path as an input (e.g. `e2e-playwright` reading a spec file).
5. `skills/engineering/README.md`, top-level `README.md`, `.claude-plugin/plugin.json` `skills` array.
6. `docs/engineering/<name>.md` following [.agents/writing-docs.md](./.agents/writing-docs.md). Neo-owned pages are in-repo only: do not point them at aihero.dev; relative repo links are allowed.
7. Update `ask-matt` in the same change.
8. `scripts/link-skills.sh` after add, remove, or rename.
9. `scripts/sync-agent-plugin-layout.sh` (promoted-name symlink at `skills/<name>` for Agent Plugins 1.0).
10. `claude plugin validate . --strict`.

## Upstream

Maintainer skill for **this repo only**: `.agents/skills/sync-upstream/`, discovered by omp via `.omp/config.yml` `skills.customDirectories`. Not under `skills/`, not in the plugin, not linked into `~/.claude/skills`. Invoke it when the user wants Matt updated. `sync-mattpocock` (neo-plugin) is the wrong direction and the wrong layout. Do not import it.

Remote: `upstream` = `git@github.com:mattpocock/skills.git` (already configured). Follow `sync-upstream` for the merge, conflict table, and post-merge scripts.

Do not flatten buckets. Do not vendor method skills from neo-plugin on top of a merge.

## Releases

Maintainer skill for **this repo only**: `.agents/skills/ship/`, same omp discovery as `sync-upstream`. Invoke it when the user wants a release. It bumps `package.json`, root `plugin.json`, and `.claude-plugin/plugin.json` together, prepends `CHANGELOG.md`, then commit / tag / push / GitHub release. Marketplace indexes have no version field.

## Agent Plugins / omp

Do not create or fork [agent-plugins.org](https://agent-plugins.org/). That site is the published 1.0 spec (Amazon / Cursor / Microsoft / OpenAI / Vercel). This repo **consumes** it.

Root `plugin.json` is the Agent Plugins manifest: closed schema (`$schema`, `name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`, `extensions` only). It MUST NOT contain a `skills` array. Claude Code keeps its path list in `.claude-plugin/plugin.json`.

omp runtime loads a plugin only when `package.json` has `omp` or `pi` (`getEnabledPlugins` skips the rest). Keep `"omp": {}` even with no extensions. Keyword `omp-package` and root `plugin.json` are not that gate.

Agent Plugins discovers only **immediate** children of `skills/` that contain `SKILL.md` (no recursion). Matt's buckets stay. `scripts/sync-agent-plugin-layout.sh` writes `skills/<name> -> <bucket>/<name>` for every promoted path in `.claude-plugin/plugin.json`. Those symlinks stay inside the plugin root.

omp install (no using-neo session extension):

```bash
omp plugin install github:witooh/neo-matt
```

Lists as `neo-matt@<version>`. `.omp-plugin/marketplace.json` is the omp catalog; day-to-day install is still `github:`.
