# ADR 002: Separate Bootstrap Module from Main Configuration

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

The pipeline needs an IAM role and S3 backend before it can run terraform. But the pipeline is what runs terraform.

```diff
- Putting OIDC and state resources in the main config: pipeline modifies its own permissions (privilege escalation risk)
+ Separate bootstrap module: runs once locally, hands over to pipeline permanently
```

---

## Decision

**Split into two terraform configurations.** `bootstrap/` runs once from a laptop with admin credentials. The root configuration runs in the pipeline from that point forward.

---

## Consequences

A new engineer joining a fresh AWS account runs bootstrap once, copies the outputs into GitHub secrets, and never touches bootstrap again. Day-to-day work happens in the root configuration via PRs.

Bootstrap state stays local intentionally. If bootstrap state lived in the same bucket it manages, deleting the bucket would also delete the record of the bucket existing.

> This is the standard pattern real engineering teams use. The bootstrap is not a workaround, it is the correct separation of concerns between account-level infrastructure and application infrastructure.

---

## What I Would Do Differently in Production

- Store bootstrap state in a dedicated ops account separate from application accounts
- Use AWS Control Tower to bootstrap new accounts automatically
- Separate IAM role creation from state bucket creation so they can be managed independently