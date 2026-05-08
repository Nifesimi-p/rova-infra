# ADR 006: Single NAT Gateway in Dev

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

NAT gateways allow private subnets to reach the internet. Each one costs around $32/month plus data processing charges.

```diff
- Per-AZ NAT gateways: high availability but ~$64/month minimum for two AZs
+ Single NAT gateway: $32/month, acceptable risk for non-production environments
```

---

## Decision

**`single_nat_gateway = true` in the current configuration.**

---

## Consequences

Roughly $32/month saved versus a per-AZ setup in a two-AZ deployment. The trade-off is that if the AZ hosting the NAT gateway has an outage, private subnets in the other AZ lose internet access. Pods can still communicate internally and reach the EKS control plane via private endpoint, but pulling new images or hitting external APIs breaks.

For dev this is the right call. The cost saving is real and a few minutes of broken outbound traffic in dev is not critical.

> In production this decision should be revisited. Per-AZ NAT gateways or VPC endpoints for ECR and S3 would eliminate this single point of failure.

---

## What I Would Do Differently in Production

- Move to per-AZ NAT gateways for true high availability
- Add VPC endpoints for ECR and S3 so the most common outbound paths bypass NAT entirely, reducing both cost and the blast radius of a NAT failure