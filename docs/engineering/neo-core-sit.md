## What it does

`neo-core-sit` inspects Core SIT: kubectl logs, OpenSearch, Argo Applications, Postgres settings in K8s secrets. Default **read-only**.

The defining constraint is **no baked AWS profile**. Missing `NEO_CORE_AWS_PROFILE`: stop. Never guess.

## When to reach for it

Type `/neo-core-sit` on "ดู log core sit" / "หา postgres บน SIT". Auxiliary cluster: [neo-aux-sit](../../skills/engineering/neo-aux-sit/SKILL.md).

## Prerequisites

`NEO_CORE_AWS_PROFILE` with region and role CoreIntegrationAccess. kubectl context `core-neo`. Mutate only if the user asks this turn.

## It's working if

- sts shows account 986629373331 + CoreIntegrationAccess.
- Reports are Thai, scannable; decoded secrets are not written to git or memory.

## Where it fits

Standalone debug. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
