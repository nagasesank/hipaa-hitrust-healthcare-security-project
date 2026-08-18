# HIPAA/HITRUST-Aligned Multi-Cloud Healthcare Security Engineering Platform

## Project Status

**Overall Status:** In Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | Healthcare Workload Design | ✅ Complete |
| Phase 2 | AWS Security Foundation | ✅ Complete |
| Phase 3 | AWS IAM Least Privilege | ✅ Complete |
| Phase 4 | Next Security Control Implementation | ⏳ Not Started |

## Architecture Strategy

- **AWS:** Primary deep implementation platform
- **GCP:** Secondary platform for control-equivalent cloud-native security objectives
- **Terraform:** Infrastructure as Code
- **AWS CLI / Cloud Console:** Validation and evidence collection
- **GitHub:** Source control and engineering history

## Current Progress

### Phase 1 — Healthcare Workload Design

Completed:

- Healthcare workload architecture
- Security requirements
- Synthetic ePHI data classification and flow
- Threat model
- HIPAA/HITRUST-informed control objectives
- Technical risk register
- Failure and attack scenarios
- Final architecture diagrams
- Architecture Decision Records

### Phase 2 — AWS Security Foundation

Completed:

- AWS VPC network foundation
- Public Edge subnet
- Private Application subnet
- Private Data subnet
- Route-table segmentation
- Terraform-managed Security Groups
- VPC Flow Logs
- CloudWatch logging
- Controlled network exposure failure
- Failure investigation
- Remediation
- Revalidation
- Terraform destroy
- AWS resource-removal verification
- Evidence collection

Phase 2 was implemented, validated, deliberately failed, investigated, remediated, revalidated, destroyed, documented, and merged.

### Phase 3 — AWS IAM Least Privilege

Completed:

- Patient API workload IAM role
- Admin API workload IAM role
- Lambda service trust relationships
- Least-privilege application audit logging permissions
- Resource-scoped CloudWatch Logs permissions
- No unnecessary S3, RDS, IAM, or EC2 permissions
- Controlled excessive-permission failure using `iam:ListRoles`
- IAM permission investigation
- Permission remediation
- Revalidation of denied excessive access
- Revalidation of legitimate log-write access
- Terraform destroy
- IAM resource-removal verification
- Empty Terraform state verification
- CLI-only evidence collection

Phase 3 was implemented, validated, deliberately given an excessive permission, investigated, remediated, revalidated, destroyed, documented, and merged.

## Engineering Methodology

Each implementation phase follows:

```text
Design
  ↓
Terraform Implementation
  ↓
Deploy
  ↓
Validate
  ↓
Capture Evidence
  ↓
Controlled Failure
  ↓
Investigate
  ↓
Remediate
  ↓
Revalidate
  ↓
Destroy
  ↓
Verify Resource Removal
  ↓
Document
  ↓
Commit
  ↓
Pull Request
  ↓
Merge
```

## Evidence

Evidence is maintained using control-oriented categories:

```text
evidence/
├── access-reviews/
├── audit-logging/
├── baseline/
├── change-management/
├── failure/
├── incident-response/
├── investigation/
├── remediation/
├── risk-management/
└── validation/
```

Phase-specific evidence uses `phase-XX-*` filenames.

## Compliance Scope

This project is a **technical security engineering exercise** aligned to selected HIPAA Security Rule and HITRUST CSF-informed control objectives.

It does **not** represent:

- HIPAA compliance
- HITRUST certification
- Formal compliance attestation
- Production healthcare deployment

All healthcare data used by the project is synthetic.

## Final Documentation

The root README will be expanded into the complete project architecture, control mapping, implementation details, validation evidence, failure scenarios, and engineering findings after all project phases are completed.
