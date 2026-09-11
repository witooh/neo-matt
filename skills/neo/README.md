# Neo

Fork-owned domain skills: HTTP/API/e2e, Jira/GitLab, Go scaffold, SIT inspect. Not a second main flow. Process stays Matt's; this bucket is on-disk ownership.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

None yet.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[markitdown](./markitdown/SKILL.md)**: Ingest a JIRA card, Confluence page, URL, or file into `docs/knowledge/` as a curated, cited entry.
- **[atlassian](./atlassian/SKILL.md)**: Jira and Confluence CLI via `acli`: command map, JQL, and write-safety gates.
- **[gitlab](./gitlab/SKILL.md)**: GitLab MRs and CI via `glab`: create, update, read, comment, inspect. Not a code review.
- **[api-spec](./api-spec/SKILL.md)**: Author the custom-YAML contract at `docs/api/`. Spec-first producer for the HTTP doc chain.
- **[openapi-doc](./openapi-doc/SKILL.md)**: Read-only drift report: Go source vs `docs/api/`.
- **[open-collection](./open-collection/SKILL.md)**: Generate a runnable Bruno OpenCollection from the api-spec.
- **[confluence-api-doc](./confluence-api-doc/SKILL.md)**: Publish the api-spec to Confluence as caller-facing pages.
- **[e2e-playwright](./e2e-playwright/SKILL.md)**: AC-driven HTTP e2e tests on a Jest + Playwright-request harness.
- **[http-audit-log](./http-audit-log/SKILL.md)**: Port one-row gin `audit_log` onto a hexagonal service.
- **[falsifying](./falsifying/SKILL.md)**: Attack a green gate to see whether it can go red.
- **[bug-hunter](./bug-hunter/SKILL.md)**: Hunt product defects no acceptance criterion asked about.
- **[attack-test](./attack-test/SKILL.md)**: Fire live HTTP abuse paths after the happy path works.
- **[init-project](./init-project/SKILL.md)**: Scaffold an empty Go hexagonal service that serves `/health`.
- **[migrate-project](./migrate-project/SKILL.md)**: Restructure an existing Go service to that blueprint, slice by slice.
- **[neo-core-sit](./neo-core-sit/SKILL.md)**: Inspect Core SIT logs, Argo, and Postgres secrets (read-only).
- **[neo-aux-sit](./neo-aux-sit/SKILL.md)**: Inspect Auxiliary SIT logs, Argo, and Postgres secrets (read-only).
