# ADR 005: Spot Instances in Dev, On-Demand in Prod

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

EKS managed node groups support ON_DEMAND or SPOT capacity.

```diff
- On-demand everywhere: predictable but expensive, no cost optimisation in non-critical environments
+ Spot in dev, on-demand in prod: saves ~66% on dev compute, production stays stable
```

---

## Decision

**Dev uses SPOT. Production uses ON_DEMAND.**

---

## Consequences

Dev environments are forgiving. If a spot node disappears, pods reschedule in a couple of minutes and engineers see a brief interruption. A t3.small on-demand in eu-west-1 costs around $21/month. The same instance on spot costs around $7/month. Across a dev cluster running 24/7 that saving is real.

Production cannot tolerate that interruption pattern. A customer-facing API does not get to be down for two minutes because AWS reclaimed a node. On-demand costs more but the predictability is the product.

> This decision is surfaced in environments/dev.tfvars and environments/prod.tfvars so the difference is explicit and reviewable in every PR.

---

## What I Would Do Differently in Production

- Use a mixed instance policy with spot for non-critical workloads and on-demand for critical ones within the same cluster
- Add Karpenter for smarter node provisioning that handles spot interruptions more gracefully than the default node group behaviour