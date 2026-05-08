# ADR 001: Use OIDC Instead of Long-Lived AWS Access Keys

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

The pipeline needs to authenticate to AWS to run terraform plan and push to ECR. Two options were on the table:

```diff
- Option A: IAM user + access keys stored in GitHub secrets (valid forever, manual rotation required)
+ Option B: OIDC trust between GitHub and AWS (short-lived tokens, nothing static to leak)
```

---

## Decision

**Option B. OIDC. No static credentials anywhere in the pipeline.**

---

## Consequences

Static keys sit in GitHub until someone manually rotates them. If a key leaks in a log, a PR, or through a GitHub breach, it is valid until rotated. Most teams forget to rotate.

OIDC fixes this at the root. GitHub mints a token per workflow run. AWS verifies the token came from this specific repository and branch before issuing credentials that expire within the hour.

> The only value stored in GitHub secrets is the role ARN. This is useless to anyone outside this repository because the trust policy rejects them at the AWS level.

---

## What I Would Do Differently in Production

- Split into two roles: read-only for terraform plan on PRs and a write role for terraform apply on merge to main only
- Separate roles per environment so the dev pipeline cannot touch prod resources
- Fetch role ARNs from AWS SSM Parameter Store at runtime instead of storing them as GitHub secrets