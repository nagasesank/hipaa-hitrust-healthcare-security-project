# HIPAA/HITRUST-Aligned Multi-Cloud Healthcare Security Engineering Platform

A production-style, portfolio-grade healthcare security engineering project for designing and implementing cloud security controls around a synthetic-ePHI healthcare workload across AWS and GCP.

> **Compliance positioning:** This is a technical security architecture and implementation project. It does **not** claim HIPAA compliance, HIPAA certification, HITRUST certification, or any formal compliance attestation.

## Project Overview

The project demonstrates an end-to-end healthcare security engineering lifecycle:

```text
Healthcare Security Requirements
            ↓
Approved Multi-Cloud Architecture
            ↓
AWS Primary Deep Implementation
            ↓
GCP Control-Equivalent Implementation
            ↓
Technical Validation & Evidence
            ↓
Controlled Security Failure Scenarios
            ↓
Investigation & Remediation
            ↓
Revalidation
            ↓
Final Security Evidence
```

The objective is to demonstrate **security engineering outcomes**, not simply cloud resource deployment.

## Architecture Strategy

- **AWS** — primary deep implementation platform
- **GCP** — secondary control-equivalent implementation
- **Data** — synthetic ePHI only
- **Infrastructure** — Terraform
- **Validation** — AWS CLI / GCP CLI and cloud-console verification where useful
- **Evidence** — implementation, validation, failure, remediation, and teardown evidence
- **Design principle** — equivalent security objectives across clouds, not one-to-one service duplication

## Security Objectives

The overall platform addresses:

- Workforce authentication and MFA
- Least-privilege human and workload identities
- Private application and data tiers
- Controlled internet ingress
- Restricted egress
- Encryption and key-management boundaries
- Secrets management
- Infrastructure and application auditability
- Configuration and security monitoring
- Threat detection and security findings
- Synthetic ePHI discovery and exposure validation where justified
- Backup and recovery security
- Incident-response automation
- Cross-cloud blast-radius reduction

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

## AWS Security Coverage

The planned AWS implementation covers security domains including:

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

## GCP Control-Equivalent Coverage

The GCP implementation maps security objectives to cloud-native controls including:

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

GCP is intentionally not treated as an exact mirror of AWS.

## Cost Model

The project is designed as a cost-conscious engineering lab:

- Prefer free-tier eligible resources where practical
- Minimize resource count
- Avoid unnecessary managed services
- Avoid production-scale capacity for demonstrations
- Keep infrastructure short-lived
- Destroy lab resources after validation
- Verify complete resource removal

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

HIPAA and HITRUST references are used as engineering and control-design reference points. This repository is not a compliance assessment, certification, legal determination, or substitute for an organizational risk assessment or formal audit.

## Project Status

**Phase 1:** Complete and merged.

**Phase 2:** AWS Security Foundation & Network Segmentation — active implementation phase.

Detailed implementation history, validation evidence, controlled failures, remediation records, and phase-specific decisions are maintained within the corresponding phase branch and its phase documentation.

> **Final project README:** The root README is intentionally maintained as the project's high-level overview. The final consolidated project state, completed phase history, architecture references, evidence index, and final outcomes will be finalized once all implementation phases are complete and merged into `main`.
