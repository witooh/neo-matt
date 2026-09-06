## What it does

`neo-aux-sit` inspects Auxiliary SIT (self-hosted Argo, multi-namespace). Same inspect-only default as Core. OpenSearch recipe is shared: `skill://neo-core-sit/references/opensearch-sit.md`.

The defining constraint is **fail fast on missing `NEO_AUX_AWS_PROFILE`**. Never invent a profile name.

## When to reach for it

Type `/neo-aux-sit` on "ดู log aux sit" / "debug auxiliary". Core cluster: [neo-core-sit](../../skills/engineering/neo-core-sit/SKILL.md).

## Prerequisites

`NEO_AUX_AWS_PROFILE`, role AuxiliaryEsignatureAccess, context `aux-neo`. Resolve Application destination namespace before logs.

## It's working if

- sts shows account 290768402609 + AuxiliaryEsignatureAccess.
- Secrets found via `scripts/pg-from-secret`; password not dumped unless asked to connect.

## Where it fits

Standalone debug. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
