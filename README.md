# neo-matt

Fork of [mattpocock/skills](https://github.com/mattpocock/skills) plus neo domain skills. One plugin.

**Process is Matt's.** Work travels `grill-with-docs` → `to-spec` / `to-tickets` → `implement` (`tdd` then `code-review`). The router is [`ask-matt`](./skills/engineering/ask-matt/SKILL.md). This fork does not ship `using-neo`.

**Neo adds domain skills**, not a second main flow: HTTP/API/e2e, Jira/GitLab, Go scaffold, SIT inspect. They live under `skills/engineering/` like every other engineering skill.

Upstream updates: project-scope omp skill `sync-upstream` (`.agents/skills/`). Releases: `ship`.

## Install

**omp** (Agent Plugins 1.0):

```bash
omp plugin install github:witooh/neo-matt
```

Lists as `neo-matt@<version>`. Update with the same command plus `--force`. Uninstall: `omp plugin uninstall neo-matt`.

Dev against a working tree: `omp plugin link <path-to-this-clone>`.

**Claude Code** (this repo as a marketplace, not Matt's official listing):

```
/plugin marketplace add witooh/neo-matt
/plugin install neo-matt@neo-matt
```

Do not install `mattpocock-skills` from Claude's official marketplace if you want this fork. That listing is Matt's plugin, not this one.

Once per target repo, run `/setup-matt-pocock-skills` so issue tracker, triage labels, and doc layout exist.

## What you get

| Layer | Skills |
|---|---|
| Main flow | `grill-with-docs`, `to-spec`, `to-tickets`, `implement`, `tdd`, `code-review` |
| On-ramps | `triage`, `diagnosing-bugs`, `wayfinder`, `markitdown`, `init-project`, `migrate-project` |
| HTTP / contract | `api-spec`, `openapi-doc`, `open-collection`, `confluence-api-doc`, `e2e-playwright` |
| Already green | `falsifying`, `bug-hunter`, `attack-test`, `improve-codebase-architecture` |
| Ops | `atlassian`, `gitlab`, `neo-core-sit`, `neo-aux-sit` |

Maintainer skills (this repo only, omp `.agents/skills/`): `sync-upstream`, `ship`.

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them (e.g. `/grill-me`); their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### Engineering

Skills used daily for code work.

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: Ask which skill or flow fits your situation. A router over the user-invoked skills in this repo.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Grilling session that also builds your project's domain model, sharpening terminology and updating `CONTEXT.md` and ADRs inline.
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: Configure this repo for the engineering skills (issue tracker, triage labels, domain doc layout). Run once per repo before using the other engineering skills.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker. No interview, just synthesizes what you've already discussed.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges, written as text in a local file, or as native blocking links on a real tracker.
- **[implement](./skills/engineering/implement/SKILL.md)**: Build the work described by a spec or set of tickets, driving `/tdd` at pre-agreed seams and closing out with `/code-review` before committing.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way to the destination is clear.

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question, either a single shareable HTML file for state/logic questions, or several radically different UI variations toggleable from one route.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions: build a feedback loop that goes red on this bug → minimise → hypothesise → instrument → fix → regression-test.
- **[research](./skills/engineering/research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Actively build and sharpen a project's domain model: challenge terms against the glossary, stress-test with edge-case scenarios, and update `CONTEXT.md` and ADRs inline.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Shared discipline and vocabulary for designing deep modules: a lot of behaviour behind a small interface, placed at a clean seam, testable through that interface.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: **Standards** (does it follow the repo's coding standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?), run as parallel sub-agents so neither pollutes the other.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: Work through an in-progress git merge or rebase conflict hunk by hunk, resolving by intent traced to each side's primary source, then finish the operation (never `--abort`).
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover.
- **[markitdown](./skills/engineering/markitdown/SKILL.md)**: Ingest a JIRA card, Confluence page, URL, or file into `docs/knowledge/` as a curated, cited entry.
- **[atlassian](./skills/engineering/atlassian/SKILL.md)**: Jira and Confluence CLI via `acli`: command map, JQL, and write-safety gates.
- **[gitlab](./skills/engineering/gitlab/SKILL.md)**: GitLab MRs and CI via `glab`: create, update, read, comment, inspect. Not a code review.
- **[api-spec](./skills/engineering/api-spec/SKILL.md)**: Author the custom-YAML contract at `docs/api/`. Spec-first producer for the HTTP doc chain.
- **[openapi-doc](./skills/engineering/openapi-doc/SKILL.md)**: Read-only drift report: Go source vs `docs/api/`.
- **[open-collection](./skills/engineering/open-collection/SKILL.md)**: Generate a runnable Bruno OpenCollection from the api-spec.
- **[confluence-api-doc](./skills/engineering/confluence-api-doc/SKILL.md)**: Publish the api-spec to Confluence as caller-facing pages.
- **[e2e-playwright](./skills/engineering/e2e-playwright/SKILL.md)**: AC-driven HTTP e2e tests on a Jest + Playwright-request harness.
- **[falsifying](./skills/engineering/falsifying/SKILL.md)**: Attack a green gate to see whether it can go red.
- **[bug-hunter](./skills/engineering/bug-hunter/SKILL.md)**: Hunt product defects no acceptance criterion asked about.
- **[attack-test](./skills/engineering/attack-test/SKILL.md)**: Fire live HTTP abuse paths after the happy path works.
- **[init-project](./skills/engineering/init-project/SKILL.md)**: Scaffold an empty Go hexagonal service that serves `/health`.
- **[migrate-project](./skills/engineering/migrate-project/SKILL.md)**: Restructure an existing Go service to that blueprint, slice by slice.
- **[neo-core-sit](./skills/engineering/neo-core-sit/SKILL.md)**: Inspect Core SIT logs, Argo, and Postgres secrets (read-only).
- **[neo-aux-sit](./skills/engineering/neo-aux-sit/SKILL.md)**: Inspect Auxiliary SIT logs, Argo, and Postgres secrets (read-only).

### Productivity

General workflow tools, not code-specific.

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Compact the current conversation into a handoff document so another agent can continue the work.
- **[teach](./skills/productivity/teach/SKILL.md)**: Teach the user a new skill or concept over multiple sessions, using the current directory as a stateful teaching workspace.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can, filled in async, or together over a meeting. It grills you about the send (who it's for, what you need back), not the subject.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Fire this the moment a message doesn't land. The agent re-pitches it with the context you're missing, in plain English, using your `CONTEXT.md` vocabulary.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea until every branch of the design tree is resolved. The reusable interview primitive behind `grill-me`, `grill-with-docs`, `triage`, `wayfinder` and `improve-codebase-architecture`.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md/CLAUDE.md, and any doc an agent reaches by a pointer.

## License

MIT. Matt's skills remain his; neo domain skills are this fork's.
