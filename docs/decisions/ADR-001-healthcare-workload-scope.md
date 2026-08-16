# ADR-001: Healthcare Workload Scope and Phase 1 Design Constraints

## Status

Accepted for Phase 1 design.

## Context

CareConnect Health Platform is being designed as a production-style, hands-on multi-cloud healthcare security engineering platform. Phase 1 must establish the design, threat model, security requirements, control objectives, and failure scenarios before any Terraform implementation or cloud deployment occurs.

The project must demonstrate strong security architecture, investigation readiness, backup isolation, controlled failure injection, and evidence-driven engineering without claiming certification or compliance guarantees.

## Decision

1. The platform will use synthetic ePHI only.
2. AWS is the primary deep implementation environment.
3. GCP is the secondary control-equivalent environment.
4. The repository remains design-first before implementation.
5. CloudFront is excluded from the initial architecture.
6. Account/project isolation is treated as a security architecture decision rather than a compliance mandate.
7. Application-level patient access auditing is mandatory.
8. KMS boundaries are separated by data/operational domain.
9. Backups are isolated as a separate security boundary.
10. Controlled failure injection is a mandatory part of the engineering method.
11. Evidence collection is treated as a first-class design requirement.

## Rationale

- Synthetic ePHI eliminates any dependency on real patient data while preserving realistic threat and control modeling.
- AWS provides the deepest primary environment for future implementation and troubleshooting workflows.
- GCP demonstrates equivalent control objectives and cross-cloud reasoning rather than superficial service mirroring.
- Deferring implementation prevents the project from drifting into unsupported infrastructure choices before architectural review.
- Excluding CloudFront avoids unnecessary architecture inflation and keeps the design focused on core healthcare security controls.
- Application-level patient access auditing closes a gap not addressed by infrastructure audit logs alone.
- Separated KMS boundaries and isolated backups reduce blast radius during compromise and support meaningful failure scenarios.
- Evidence-first design supports reviewability, repeatability, and later assessment support.

## Alternatives Considered

| Alternative | Why not selected |
| --- | --- |
| Use real or de-identified patient data | Rejected due to unnecessary risk and no requirement for real data |
| Treat AWS and GCP as exact one-to-one mirrors | Rejected because security objectives matter more than identical services |
| Begin Terraform and cloud deployment before design review | Rejected because it would freeze implementation details prematurely |
| Use CloudTrail as sufficient patient auditing | Rejected because it cannot express patient/resource access intent and application context |
| Use one universal KMS key | Rejected because it weakens separation of duties and blast-radius control |
| Treat backups as ordinary copies within production access scope | Rejected because deletion and ransomware scenarios require stronger isolation |

## Consequences

Positive consequences:

- Clear architectural guardrails before implementation
- Better consistency across AWS/GCP control reasoning
- Improved ability to review threat, detection, and evidence design early
- Reduced risk of premature implementation sprawl

Trade-offs:

- Some implementation choices remain unresolved in Phase 1
- More design effort is required before infrastructure work begins
- Cost-sensitive security tooling choices remain subject to later review

## Explicit Non-Goals

- No Terraform implementation in Phase 1
- No cloud deployment
- No IAM policy authoring
- No security group or firewall rule authoring
- No GitHub Actions workflow creation
- No architecture image generation
- No claim of HIPAA compliance or HITRUST certification

## OPEN DECISIONS

- Exact AWS account structure
- Exact GCP project structure
- Exact application compute platform
- Exact database engine
- Exact use of Macie and GCP Sensitive Data Protection/DLP based on cost and evidence value
