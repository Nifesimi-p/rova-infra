# Architecture Decision Records

Each ADR captures a decision made while building this, what was considered, 
and why we went the way we did.

| ADR | Decision |
|-----|----------|
| [001](./001-oidc-over-access-keys.md) | Use OIDC instead of long-lived AWS access keys |
| [002](./002-bootstrap-as-separate-module.md) | Separate bootstrap module from main configuration |
| [003](./003-immutable-image-tags.md) | Immutable ECR image tags |
| [004](./004-pdb-min-available.md) | PDB minAvailable of 1 in dev, 50% in prod |
| [005](./005-spot-in-dev-only.md) | Spot instances in dev, on-demand in prod |
| [006](./006-single-nat-gateway.md) | Single NAT gateway in dev |