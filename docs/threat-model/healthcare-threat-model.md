# CareConnect Health Platform Threat Model

## Purpose

Describe the assets, actors, trust boundaries, attack surfaces, threat scenarios, and required mitigations for the CareConnect Health Platform.

## Security Objectives

1. Protect synthetic ePHI from unauthorized disclosure, modification, and deletion.
2. Prevent unauthorized patient/resource access at the application layer.
3. Preserve centralized auditability for both application and infrastructure activity.
4. Detect privileged misuse, drift, and credential compromise quickly.
5. Preserve recoverability following destructive or ransomware-style events.

## Assets

| Asset ID | Asset | Why it matters |
| --- | --- | --- |
| A1 | Patient API | Entry point for patient data access |
| A2 | Admin API | Higher-risk privileged application path |
| A3 | Private application tier | Central policy enforcement and data mediation point |
| A4 | Database | Structured synthetic ePHI store |
| A5 | PHI object storage | Unstructured synthetic ePHI store |
| A6 | KMS domains | Encryption and decrypt-authority boundary |
| A7 | Identity plane | Authentication and privileged access control |
| A8 | Audit and security plane | Detection, evidence, and investigation visibility |
| A9 | Backup and recovery plane | Recovery from deletion and destructive events |
| A10 | IaC / CI-CD plane | Desired-state and change-authority boundary |

## Threat Actors

| Actor ID | Actor | Motivation / capability |
| --- | --- | --- |
| T1 | External attacker | Opportunistic or targeted exploitation from the internet |
| T2 | Compromised application | Malicious behavior through a trusted workload path |
| T3 | Malicious or compromised workforce user | Abuse of legitimate application access |
| T4 | Compromised IAM / cloud credentials | Cloud-plane misuse and privilege escalation |
| T5 | Insider / configuration change actor | Intentional or accidental security degradation |
| T6 | Compromised CI/CD identity | Undermining desired-state authority or supply chain |
| T7 | Cross-cloud credential compromise | Lateral misuse across AWS and GCP boundaries |

## Trust Boundaries

| Boundary ID | Description | Representative controls |
| --- | --- | --- |
| TB-01 | Internet | TLS, edge controls, authentication |
| TB-02 | Edge/WAF | WAF, load balancing, request filtering |
| TB-03 | Application tier | Workload IAM, app authorization, private runtime |
| TB-04 | PHI data tier | Private networking, KMS, storage/database authz |
| TB-05 | Security/audit plane | Centralized logging, restricted log access |
| TB-06 | Backup/recovery plane | Backup isolation, retention, deletion protection |
| TB-07 | Identity plane | Federated identity, MFA, session governance |
| TB-08 | CI/CD and infra-management plane | Change control, secret separation, least privilege |
| TB-09 | AWS/GCP cloud boundary | Credential separation, blast-radius isolation |

## Attack Surfaces

- Public edge and API exposure
- Workforce/admin login surfaces
- Application authorization logic
- Database and object-storage access paths
- KMS authorization boundaries
- Log ingestion and retention paths
- Backup administration surfaces
- IaC / CI-CD identities and change paths
- Cross-cloud operator credential reuse

## Threat Scenarios

| Scenario | Threat summary | Primary actors | Primary assets |
| --- | --- | --- | --- |
| F01 | Public storage exposure | T1, T5 | A5 |
| F02 | IAM over-privilege | T4, T5 | A3, A4, A5, A8 |
| F03 | KMS authorization failure | T5, T2 | A4, A5, A6 |
| F04 | Database/network exposure | T1, T5 | A4 |
| F05 | WAF control failure | T1 | A1, A2 |
| F06 | Audit logging failure | T4, T5 | A8 |
| F07 | Credential compromise | T4 | A7, A8 |
| F08 | ePHI exfiltration | T2, T3, T4 | A4, A5 |
| F09 | Mass ePHI deletion | T3, T4, T5 | A4, A5, A9 |
| F10 | Terraform/configuration drift | T5, T6 | A8, A10 |
| F11 | Insider VIP snooping | T3 | A1, A3, A4 |
| F12 | IDOR / broken object-level authorization | T1, T3 | A1, A2, A4, A5 |
| F13 | CI/CD supply-chain compromise | T6 | A10, A3, A8 |
| F14 | Ransomware-style destructive activity | T2, T4 | A4, A5, A9 |
| F15 | Public database/snapshot exposure | T1, T5 | A4 |
| F16 | MFA/session abuse | T3, T4 | A7, A2 |
| F17 | Cross-cloud credential abuse | T4, T7 | A7, A8, A10 |

## Attack Paths

### External Entry to Data Access

TB-01 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-02 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-03 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-04

Primary controls:

- WAF and ingress filtering
- Application authentication and authorization
- Private data tier
- KMS-backed encryption

### Workforce Privilege Misuse

TB-07 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-01 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-02 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-03 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-04 / TB-05

Primary controls:

- MFA
- RBAC and least privilege
- Application-level patient access audit
- Investigation-ready security telemetry

### Cloud Credential Abuse

TB-08 / TB-07 ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ TB-05 / TB-04 / TB-06 / TB-09

Primary controls:

- Credential separation
- Narrow IAM roles
- Config and threat detection
- Backup isolation

## Mitigations

| Threat focus | Mitigation expectations |
| --- | --- |
| Unauthorized internet access | Edge/WAF protections, private data tier, no public data stores |
| Over-privileged identities | Least privilege, separation of duties, role scoping |
| Application-level misuse | Record/object authorization, patient access auditing, purpose-of-use capture where applicable |
| Destructive data events | Protected backups, deletion protection, restore testing |
| Logging blind spots | Mandatory infra + app auditing, centralized evidence |
| Drift and out-of-band change | Desired-state authority and drift detection |
| Cross-cloud misuse | Credential separation and independent audit paths |

## Detection Requirements

- Detect public exposure of storage and database boundaries.
- Detect unusual access to patient-linked records or objects.
- Detect KMS authorization failures affecting application availability.
- Detect audit-log suppression or logging gaps.
- Detect privileged change drift and suspicious credential use.
- Detect attempted backup compromise or destructive operations.

## Investigation Requirements

- Correlate application audit events with cloud-native audit logs.
- Preserve actor identity, role, target, action, timestamp, and correlation ID.
- Distinguish patient-level access events from cloud control-plane events.
- Capture root-cause evidence for identity misuse, drift, and destructive operations.

## Recovery Requirements

- Validate restoration of database and object data from protected backups.
- Demonstrate recovery after deletion and destructive scenarios.
- Preserve evidence of both attack symptoms and successful remediation.

## OPEN DECISIONS

- Exact threat-detection content and severity thresholds remain **OPEN DECISION**.
- Exact CI/CD platform architecture remains **OPEN DECISION**.
- Exact compute/runtime-specific attack surfaces remain **OPEN DECISION** until implementation platform choice is approved.
