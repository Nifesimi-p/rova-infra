# ADR 003: Immutable ECR Image Tags

| | |
|---|---|
| **Status** | Accepted |
| **Date** | 2026-05-08 |
| **Decider** | Nifesimi-p |

---

## Context

ECR repositories support either MUTABLE or IMMUTABLE tags.

```diff
- Mutable tags: the same tag can be overwritten with a different image at any time
+ Immutable tags: once a tag is set, it is locked to that image forever
```

---

## Decision

**Immutable tags, with images tagged by git commit SHA.**

---

## Consequences

If someone reports a bug in production and the deployment says `image: rova-microservice:sha-a3f9c12`, that exact image still exists in ECR and can be pulled locally to reproduce the bug. With mutable tags and `:latest`, the image that was running when the bug happened may have been overwritten ten times since.

Rollbacks are trivial. The previous SHA tag still exists, point the deployment at it and done.

> The default tag in values.yaml is set to `dev-local` instead of `latest` to stay consistent with this policy. The pipeline always overrides it with the real SHA tag at deploy time.

---

## What I Would Do Differently in Production

- Keep the last 20 releases instead of 10 to give more rollback headroom
- Tag images with both the SHA and the semantic version when releases are cut, so `sha-a3f9c12` and `v1.2.0` point to the same image