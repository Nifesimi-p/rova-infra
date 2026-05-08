# ADR 004: PDB minAvailable of 1 in Dev, 2 in Prod

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

A Pod Disruption Budget tells kubernetes the minimum availability needed during voluntary disruptions like node drains or cluster upgrades.

```diff
- Too loose: a node drain takes all pods down at once, causing downtime
+ Too tight: node drains hang forever, blocking cluster maintenance and upgrades
```

---

## Decision

**Dev uses `minAvailable: 1`. Production uses `minAvailable: 2` out of 3 replicas.**

---

## Consequences

In dev with one or two replicas, `minAvailable: 1` means at least one pod is always serving traffic but the cluster can still drain nodes. Using a percentage in dev with one replica would mean kubernetes could never drain the node, blocking cluster upgrades.

In production with three replicas, `minAvailable: 2` means kubernetes will never voluntarily evict more than one pod at a time. The remaining two carry traffic while the evicted pod reschedules on a new node.

> Both values are configurable in values.yaml and values-prod.yaml. The chart supports switching between minAvailable and maxUnavailable depending on what the workload needs.

---

## What I Would Do Differently in Production

- Use percentage-based values tied to replica count so the PDB scales automatically as replicas change
- Add a maxUnavailable option in values.yaml so teams can choose which constraint fits their workload