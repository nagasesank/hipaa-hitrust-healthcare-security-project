# CareConnect Health Platform Architecture

## Purpose

Define the Phase 1 security architecture for the CareConnect Health Platform, a production-style multi-cloud healthcare workload that processes synthetic ePHI only. This document establishes the logical architecture, security objectives, AWS primary design direction, GCP control-equivalent direction, and explicit non-goals before any Terraform implementation begins.

## Scope

- Design only for workload, security, logging, audit, backup, and incident-response architecture
- AWS as the primary deep implementation environment
- GCP as the secondary control-equivalent environment
- Synthetic ePHI protection requirements
- Trust boundaries, identities, and control responsibilities
- Phase 1 architecture decisions and exclusions

Out of scope for Phase 1:

- Terraform implementation
- Cloud resource deployment
- Provider configuration
- IAM policy authoring
- Security group or firewall rule authoring
- CI/CD workflow implementation
- Diagram generation

## Workload Description

CareConnect Health Platform is a healthcare application platform for synthetic patient access and workforce administration flows. The workload exposes separate patient-facing and workforce/admin-facing APIs, processes synthetic ePHI, and requires application-level patient access auditing in addition to infrastructure audit logging.

Core logical components:

- Patient/User access path
- Workforce/admin access path through federated identity and MFA
- Patient API
- Admin API
- Private application tier
- Database tier
- PHI object storage tier
- KMS-backed encryption domains
- Security and audit plane
- Backup and recovery plane
- Incident response automation plane

## Logical Architecture

```text
Users
  |
  +-- Patient/User
  |
  +-- Workforce
          |
       IdP + MFA
          |
   +------+------+
   |             |
Patient API    Admin API
   |             |
   +------+------+
          |
    Private Application Tier
          |
     +----+----+
     |         |
  Database   PHI Object Storage
     |              |
    KMS            KMS
     |              |
     +------+-------+
            |
       Security Plane
            |
    +-------+--------+---------+---------+
    |       |        |         |         |
Audit   Config   Threat    Security   Data
Logs    Drift    Detect    Aggregation Protection
            |
       Event Routing
            |
     Incident Response
            |
       Backup / Recovery
```

## Design Principles

1. Least privilege across human and workload identities.
2. No unnecessary direct access to synthetic ePHI.
3. MFA is mandatory for workforce and administrative access.
4. Application and data tiers remain private by default.
5. Encryption at rest and in transit is mandatory.
6. Key administration is separated from key usage.
7. Application-level patient access auditing is required.
8. Infrastructure audit logging is necessary but insufficient alone.
9. Security telemetry must support detection, investigation, and evidence capture.
10. Backups are a separate security boundary.
11. Controlled failure injection is part of the engineering method.
12. AWS and GCP controls are equivalent by security objective, not service name.
13. Implementation should minimize unnecessary service sprawl and cost.

## Security Planes

### Identity Plane

- Federated identity provider for workforce authentication
- MFA enforcement for workforce and privileged access
- Distinct human and workload identities
- Segregation of administrative, security, backup, and application responsibilities
- Application authorization separate from cloud IAM

### Data Plane

- Patient API and Admin API terminate at the edge and route to a private application tier
- Database and PHI object storage reside in the private data tier
- Application is the only intended consumer of ePHI data stores
- Application-level audit events are generated for patient/resource access

### Security Plane

- Infrastructure audit logging
- Configuration compliance and drift detection
- Threat detection and aggregation
- Sensitive data discovery where justified
- Event routing into incident response workflows

### Backup Plane

- Backups encrypted with separate logical key boundaries
- Backup access restricted from ordinary production operators
- Recovery testing required
- Deletion protection and immutability are design requirements

## AWS Architecture

AWS is the primary implementation environment because it will host the deepest hands-on control implementation, failure injection, investigation, remediation, and evidence collection.

### AWS Control Areas

| Control area | Role in design | Status |
| --- | --- | --- |
| Account boundary / AWS Organizations | Reduce blast radius, separate workload, logging, security, and backup administration where justified | OPEN DECISION |
| Federated identity + MFA | Workforce/admin authentication and privileged access control | Required |
| IAM | Least privilege for human and workload identities | Required |
| VPC | Network isolation for edge, application, data, and management paths | Required |
| Application compute | Host private patient/admin application services | Required |
| ALB | Controlled ingress to application services | Required |
| AWS WAF | Edge-layer request filtering and abuse detection | Required |
| Database layer | Private structured ePHI persistence | Required |
| S3 object storage | Private unstructured ePHI storage and controlled access | Required |
| AWS KMS | Encryption boundary separation for ePHI, database, logs, backups, and secrets | Required |
| Secrets Manager | Secret storage and rotation boundary | Required |
| CloudTrail | Control-plane audit logging | Required |
| CloudWatch and VPC Flow Logs | Metrics, application telemetry integration, and network observability | Required |
| AWS Config | Configuration compliance and drift detection | Required |
| GuardDuty | Threat detection | Required |
| Security Hub | Security finding aggregation | Required |
| Macie | Sensitive data discovery where justified for synthetic ePHI exposure validation | OPEN DECISION |
| EventBridge | Security event routing into investigation and response workflows | Required |
| Lambda/automation | Response orchestration only where justified | OPEN DECISION |
| AWS Backup | Protected backup and recovery orchestration | Required |
| CloudFront | Not required for Phase 1 because the primary objective is security control depth, not global content acceleration | Explicitly excluded initially |

### AWS Architecture Notes

- Direct internet access to the data tier is prohibited.
- Workforce administration must not bypass federated identity and MFA.
- CloudTrail is required for infrastructure auditability but cannot satisfy patient-level access auditing on its own.
- Database engine and compute runtime remain **OPEN DECISION** until implementation trade-offs are approved.

## GCP Architecture

GCP is the secondary environment used to demonstrate equivalent security objectives with different native controls and operational trade-offs.

### GCP Control Areas

| Control area | Security objective | GCP direction | Status |
| --- | --- | --- | --- |
| Project boundary | Reduce blast radius and separate privileged domains | Separate workload, logging/security, and backup concerns where justified | OPEN DECISION |
| Federated identity + MFA | Strong workforce authentication | Federated identity integration and MFA enforcement | Required |
| IAM | Least privilege | Narrow human/workload roles | Required |
| VPC and firewall controls | Network segmentation | Private application/data tiers with controlled ingress/egress | Required |
| Application compute | Private application hosting | Private compute service with no direct data-tier exposure | Required |
| HTTPS Load Balancer | Controlled ingress | Edge entry point for APIs | Required |
| Cloud Armor | Edge filtering and request protection | GCP equivalent to WAF objective | Required |
| Cloud SQL / database layer | Structured ePHI persistence | Private database boundary | Required |
| Cloud Storage | Unstructured ePHI storage | Private object storage boundary | Required |
| Cloud KMS | Encryption boundary separation | Separate logical keys for data classes and operations | Required |
| Secret Manager | Secret storage | Protected secret boundary | Required |
| Cloud Audit Logs | Control-plane auditability | Infrastructure auditing | Required |
| Cloud Logging and Monitoring | Telemetry collection and analysis | Observability and security signal support | Required |
| Security Command Center | Security posture and finding aggregation | Threat and posture aggregation | Required |
| Sensitive Data Protection / DLP | Sensitive data discovery and validation | Use only where justified by control objective and lab cost | OPEN DECISION |
| Backup / recovery controls | Protected recovery path | Encrypted and access-restricted backup design | Required |

### AWS/GCP Differences by Design

- AWS Security Hub and GuardDuty map to the security-finding and threat-detection objectives served in GCP by Security Command Center plus native logging/monitoring integrations.
- AWS Config is a more explicit configuration-compliance service; in GCP the equivalent objective is met through logging, policy, and posture tooling rather than a one-to-one service mirror.
- Macie and Sensitive Data Protection/DLP satisfy related discovery objectives but may be scoped differently due to cost and lab practicality.

## Identity Plane

Human identities:

- Patient/User
- Workforce user
- Security operator
- Backup administrator
- Infrastructure administrator
- CI/CD identity operator

Workload identities:

- Patient API workload identity
- Admin API workload identity
- Backup/recovery workload identity
- Incident-response automation identity

Identity requirements:

- Workforce/admin access must use federated identity and MFA.
- Workload identities must not inherit human administrator privileges.
- Application authorization must enforce patient/resource access decisions separate from cloud IAM.

## Data Plane

Primary data classes:

- Synthetic patient profile data
- Synthetic clinical records
- Synthetic documents/objects
- Application audit events
- Security telemetry
- Backup artifacts

Data plane requirements:

- Private application tier mediates all ePHI access.
- Database and object storage remain logically distinct data stores.
- Application logs must avoid unnecessary sensitive payloads.
- Application-level patient access auditing is mandatory.

## Backup Plane

Backup design requirements:

- Encryption with backup-specific key boundaries
- Restricted access separate from production application operators
- Protected retention and deletion controls
- Recovery testing as a mandatory validation activity
- Evidence capture for backup success, restore success, and attempted compromise scenarios

Mass ePHI deletion must assume backup-target compromise is attempted and must validate recoverability.

## Account / Project Isolation

Isolation is treated as a security architecture decision, not a compliance claim.

Security objectives:

- Reduce blast radius
- Separate workload administration from security and logging administration
- Protect audit data
- Isolate privileged backup operations
- Limit cross-cloud credential impact

**OPEN DECISION:** final number of AWS accounts and GCP projects. Phase 1 assumes logical isolation domains, with the exact count deferred until implementation trade-offs are approved.

## Component Responsibilities

| Component | Responsibility |
| --- | --- |
| Edge load balancing and WAF plane | Controlled ingress, TLS termination strategy, request filtering, edge telemetry |
| Patient API | Patient-facing request handling and authorization enforcement |
| Admin API | Workforce/admin operations with stronger access controls and audit visibility |
| Private application tier | Business logic, database/object mediation, patient access audit emission |
| Database | Structured synthetic ePHI persistence |
| PHI object storage | Unstructured synthetic ePHI persistence |
| KMS domains | Separate encryption control domains for data, logs, secrets, and backups |
| Audit plane | Infrastructure and application audit capture |
| Detection plane | Threat and configuration-drift visibility |
| Backup plane | Backup creation, retention, integrity, and restore support |
| Incident-response plane | Event routing, investigation support, and remediation orchestration hooks |

## Mandatory Engineering Methodology

Every future implementation phase must follow:

CREATE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TERRAFORM RUN/APPLY
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ VALIDATE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ SCREENSHOTS/EVIDENCE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ CONTROLLED FAILURE INJECTION
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TROUBLESHOOT/INVESTIGATE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ REMEDIATE/FIX
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ REVALIDATE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ REMEDIATION EVIDENCE
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TERRAFORM DESTROY
ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ VERIFY RESOURCE REMOVAL

Phase 1 documents the method only. No implementation is performed here.

## Explicit Exclusions

- No real PHI or ePHI
- No Terraform implementation
- No provider configuration
- No cloud deployment
- No GitHub Actions workflows
- No architecture images or diagrams in this phase
- No claim of HIPAA compliance or HITRUST certification
- No default use of CloudFront
- No assumption that every listed cloud service will be deployed
