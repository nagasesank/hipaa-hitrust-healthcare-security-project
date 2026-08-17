# HIPAA/HITRUST-Aligned Multi-Cloud Healthcare Security Engineering Platform

A production-style, portfolio-grade healthcare security engineering project demonstrating how a synthetic-ePHI healthcare workload can be designed, secured, validated, attacked in a controlled manner, remediated, and evidenced across AWS and GCP.

> **Compliance positioning:** This is a technical security architecture and implementation project. It does **not** claim HIPAA compliance, HIPAA certification, HITRUST certification, or any formal compliance attestation.

## Executive View

The project uses **AWS as the primary deep implementation platform** and **GCP as a secondary control-equivalent platform**.

The engineering objective is not to reproduce every AWS service in GCP. Instead, the project demonstrates equivalent security objectives across cloud providers while maintaining a common healthcare threat model, control model, evidence model, and failure/remediation methodology.

```text
                    HIPAA / HITRUST-INFORMED
                       SECURITY OBJECTIVES
                                │
                                ▼
                 ┌──────────────────────────┐
                 │ Healthcare Workload      │
                 │ Synthetic ePHI only     │
                 └────────────┬─────────────┘
                              │
                ┌─────────────┴─────────────┐
                ▼                           ▼
        ┌─────────────────┐       ┌─────────────────┐
        │ AWS             │       │ GCP             │
        │ Primary Deep    │       │ Control-        │
        │ Implementation  │       │ Equivalent      │
        └────────┬────────┘       └────────┬────────┘
                 │                         │
                 └────────────┬────────────┘
                              ▼
                 ┌──────────────────────────┐
                 │ Validation & Evidence    │
                 │ CLI / Console / Tests   │
                 └────────────┬─────────────┘
                              ▼
                 ┌──────────────────────────┐
                 │ Controlled Failure       │
                 │ → Investigation          │
                 │ → Remediation            │
                 │ → Revalidation           │
                 └────────────┬─────────────┘
                              ▼
                 ┌──────────────────────────┐
                 │ Destroy & Verify         │
                 │ No residual lab infra    │
                 └──────────────────────────┘
```

## Project Goals

- Translate healthcare security requirements into concrete cloud security controls.
- Maintain private application and data boundaries for synthetic ePHI.
- Apply least privilege, encryption, secrets management, logging, detection, backup, and incident-response controls.
- Demonstrate security failures deliberately rather than only showing successful deployments.
- Produce auditable engineering evidence for each implementation phase.
- Compare AWS and GCP through control objectives rather than superficial service-by-service parity.
- Keep the implementation cost-conscious and destroy short-lived lab infrastructure after validation.

## Phase Roadmap

| Phase | Focus | Status |
|---|---|---|
| **01** | Healthcare Workload Design | **Complete** |
| **02** | AWS Security Foundation & Network Segmentation | **In Progress** |
| **03** | AWS IAM & Workload Identity | Planned |
| **04** | KMS Encryption Boundaries & Secrets | Planned |
| **05** | Application Compute, ALB & WAF | Planned |
| **06** | RDS & S3 Synthetic ePHI Data Plane | Planned |
| **07** | Audit Logging, Config & Observability | Planned |
| **08** | Threat Detection & Security Findings | Planned |
| **09** | Backup & Recovery Isolation | Planned |
| **10** | Incident Response & Automation | Planned |
| **11** | GCP Control-Equivalent Implementation | Planned |
| **12** | Cross-Cloud Attack Scenarios & Final Evidence | Planned |

## Phase 1 — Healthcare Workload Design

**Status: Complete and merged to `main`.**

Phase 1 established the approved source-of-truth design before cloud implementation began.

Key outputs:

- Healthcare workload architecture
- AWS primary security architecture
- GCP control-equivalent architecture
- Synthetic ePHI data classification
- ePHI data flows
- Trust boundaries
- Security requirements
- Threat model
- Architecture decisions
- HIPAA Security Rule-aligned technical control objectives
- HITRUST CSF-informed control mapping
- Initial technical risk register
- Failure and attack scenario register
- Six finalized architecture diagrams

Detailed phase documentation is maintained under `docs/`, `compliance/`, `attack-scenarios/`, and `diagrams/`.

## Phase 2 — AWS Security Foundation & Network Segmentation

**Status: In Progress**

Phase 2 begins the deep AWS implementation using the Phase 1 architecture as the source of truth.

The phase focuses on establishing the network and security foundation before application, database, storage, WAF, detection, and response services are introduced.

Primary objectives:

- VPC isolation
- Edge, application, and data-tier segmentation
- Controlled routing
- Security-group enforcement
- Private data-tier boundary
- Network traffic visibility through VPC Flow Logs
- Minimal cost-conscious infrastructure

Primary control objectives:

- **CO-02 — Least Privilege**
- **CO-03 — Private Data-Tier Isolation**
- **CO-06 — Infrastructure Auditability**

The phase will follow the standard project lifecycle of implementation, validation, controlled failure, investigation, remediation, revalidation, evidence collection, destruction, and resource-removal verification.

## Security Control Areas

The overall implementation is expected to cover:

### AWS

- IAM / MFA / workload identity
- VPC and network segmentation
- ALB and AWS WAF
- Application compute
- RDS
- S3
- AWS KMS
- Secrets Manager
- CloudTrail
- CloudWatch / VPC Flow Logs
- AWS Config
- GuardDuty
- Security Hub
- Macie where justified
- EventBridge and response automation where justified
- AWS Backup

### GCP Control Equivalents

- Cloud IAM
- VPC and firewall controls
- HTTPS Load Balancing
- Cloud Armor
- Cloud SQL
- Cloud Storage
- Cloud KMS
- Secret Manager
- Cloud Audit Logs
- Cloud Logging / Monitoring
- Security Command Center
- Sensitive Data Protection/DLP where justified
- Backup and recovery controls

Not every service will be deployed in every phase. Service selection is driven by the approved architecture, security objective, evidence value, and cost.

## Evidence-Driven Engineering Methodology

Every hands-on phase follows:

```text
CREATE
  ↓
TERRAFORM PLAN/APPLY
  ↓
TECHNICAL VALIDATION
  ↓
CONSOLE VALIDATION WHERE USEFUL
  ↓
EVIDENCE / SCREENSHOTS
  ↓
CONTROLLED FAILURE INJECTION
  ↓
TROUBLESHOOT / INVESTIGATE
  ↓
REMEDIATE / FIX
  ↓
REVALIDATE
  ↓
REMEDIATION EVIDENCE
  ↓
TERRAFORM DESTROY
  ↓
VERIFY RESOURCE REMOVAL
```

A phase is not considered complete merely because Terraform applies successfully. Completion requires implementation, security validation, applicable failure handling, remediation, evidence, cleanup, documentation, and Git closure.

## Cost Guardrails

- Prefer free-tier eligible resources where practical.
- Avoid unnecessary managed services.
- Avoid production-scale capacity for portfolio demonstrations.
- Keep infrastructure short-lived.
- Destroy resources after evidence collection.
- Verify that resources are completely removed.
- Introduce a managed service only when it materially improves the security objective or evidence quality.

## Repository Structure

```text
.
├── attack-scenarios/
├── compliance/
├── diagrams/
├── docs/
├── evidence/
├── policies/
├── runbooks/
├── scripts/
├── templates/
├── terraform/
│   ├── aws/
│   └── gcp/
└── tests/
```

## Compliance Disclaimer

HIPAA and HITRUST references in this repository are used as engineering and control-design reference points. This project is not a compliance assessment, certification, legal determination, or substitute for an organizational risk assessment or formal audit.

## Project Status

**Phase 1:** Complete and merged.

**Phase 2:** AWS Security Foundation & Network Segmentation — implementation phase starting.
