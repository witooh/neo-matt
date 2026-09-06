## What it does

`attack-test` fires abuse paths over **live HTTP** after the happy path works: skip-step, forge-proof, replay, IDOR, tamper, state abuse.

The defining constraint is **status + body, or it did not happen**. Static reads are candidates, not HACKED.

## When to reach for it

Type `/attack-test` on "try hack" / "transfer without OTP?". Needs a running stack (local/SIT) and two test identities.

Not for latent code hunts (`bug-hunter`) or gate audits (`falsifying`).

## Prerequisites

Base URL, flow order, two sentinel identities, auth scheme. Missing: stop and ask. No production customers.

## It's working if

- Baseline recorded PASS (or BASELINE_FAIL stopped the run).
- Every finding has reproduce + impact + fix (named invariant).
- Untested groups are listed, not implied green.

## Where it fits

Codebase health after happy path. Map: [ask-matt](../../skills/engineering/ask-matt/SKILL.md).
