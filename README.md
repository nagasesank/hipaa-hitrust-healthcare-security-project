# Phase 2 — AWS Security Foundation & Network Segmentation

**Project:** HIPAA/HITRUST-Aligned Multi-Cloud Healthcare Security Engineering Platform  
**Phase:** 02  
**Branch:** `phase/02-aws-security-foundation`  
**Status:** In Progress

> This phase is an implementation exercise aligned to selected HIPAA Security Rule objectives and HITRUST CSF-informed control objectives. It does not claim HIPAA compliance, HITRUST certification, or any formal compliance attestation.

## Phase Objective

Implement the minimum AWS security and network foundation required to enforce the trust boundaries defined in Phase 1 before introducing application, database, storage, WAF, detection, and response workloads.

Phase 1 remains the architectural source of truth. This phase must not redesign the approved workload architecture.

## Phase 2 Scope

### In Scope

- AWS VPC
- Public edge subnet(s)
- Private application subnet(s)
- Private data subnet(s)
- Internet Gateway
- Route tables and routes
- Security Groups
- VPC Flow Logs
- Minimal IAM required for phase operations and validation
- Terraform modules and environment configuration
- Technical validation and console validation where useful
- Controlled network exposure failure
- Investigation and remediation
- Evidence collection
- Terraform destroy and resource-removal verification

### Out of Scope

- Application compute
- Application Load Balancer
- AWS WAF
- RDS
- S3 ePHI storage
- KMS implementation
- Secrets Manager
- GuardDuty
- Security Hub
- AWS Config
- Backup implementation
- EventBridge response automation
- GCP implementation

Each deferred service will be introduced only when its specific control objective is implemented and validated.

## Security Boundary

```text
                         Internet
                            │
                            ▼
                    ┌───────────────┐
                    │  Edge Tier    │
                    │ Public Subnet │
                    └───────┬───────┘
                            │
                     Controlled Path
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Application Tier    │
                 │ Private Subnet      │
                 └──────────┬──────────┘
                            │
                    Explicitly Allowed
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Data Tier           │
                 │ Private Subnet      │
                 └─────────────────────┘

Internet ─────────────X────────────> Data Tier
```

The primary security property is that the data tier has no direct public internet path.

## Primary Control Objectives

| Control Objective | Phase 2 Implementation |
|---|---|
| **CO-02 — Least Privilege** | Restrictive network access paths and security-group rules |
| **CO-03 — Private Data-Tier Isolation** | Private data subnet and absence of direct internet route |
| **CO-06 — Infrastructure Auditability** | VPC Flow Logs and infrastructure validation evidence |

## AWS Services

| Service | Purpose | Phase 2 |
|---|---|---:|
| Amazon VPC | Network isolation | ✅ |
| Subnets | Tier segmentation | ✅ |
| Internet Gateway | Public edge boundary | ✅ |
| Route Tables | Explicit traffic paths | ✅ |
| Security Groups | Network access control | ✅ |
| VPC Flow Logs | Network visibility | ✅ |
| CloudWatch Logs | Flow-log destination if required | Minimal |
| IAM | Required execution/validation permissions | Minimal |
| NAT Gateway | General private egress | ❌ |
| ALB | Application ingress | Later |
| WAF | HTTP protection | Later |
| RDS | Database | Later |
| S3 | ePHI object storage | Later |

### Cost Decision — No NAT Gateway

A NAT Gateway is deliberately excluded from Phase 2. This phase does not require general outbound internet access from private workloads, so introducing NAT solely for architectural appearance would create unnecessary cost.

## GCP Control-Equivalent Position

GCP is not implemented in this phase. Equivalent objectives are documented for later implementation:

| Security Objective | AWS | GCP Equivalent |
|---|---|---|
| Network isolation | VPC | VPC |
| Network access control | Security Groups | VPC firewall rules |
| Private application tier | Private subnet | Private subnet / private compute |
| Private data tier | Private subnet | Private Cloud SQL / private subnet |
| Network visibility | VPC Flow Logs | VPC Flow Logs / Cloud Logging |
| Identity | AWS IAM | Cloud IAM |

## Terraform Scope

Phase 2 modifies only the AWS network/security-foundation area.

```text
terraform/aws/
├── environments/
│   └── lab/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── terraform.tfvars.example
│
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── versions.tf
    │
    └── iam/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
```

The `network` module owns the Phase 2 network boundary. Application-specific identities and workload resources are intentionally deferred.

## Validation Strategy

### Terraform

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
terraform apply
```

### AWS CLI

```bash
aws ec2 describe-vpcs
aws ec2 describe-subnets
aws ec2 describe-route-tables
aws ec2 describe-security-groups
aws ec2 describe-flow-logs
```

### Security Validation

The validation must prove both positive and negative properties:

```text
Internet → Data Tier          DENIED
Internet → Private App Tier   DENIED
Application → Data Tier       ALLOWED only where explicitly required
Unnecessary egress             DENIED / absent
Flow logging                   ENABLED
```

A successful Terraform apply alone is not sufficient evidence.

## Controlled Failure Scenario

### F04 — Network / Database Exposure

Phase 1 defines network/data exposure as a controlled failure scenario.

Because RDS is not yet implemented, Phase 2 demonstrates the underlying network-control failure rather than deploying a database solely for testing.

```text
Baseline
   ↓
Introduce overly permissive security-group rule
   ↓
Validate unintended exposure
   ↓
Capture evidence
   ↓
Investigate route / security-group configuration
   ↓
Remove unauthorized access
   ↓
Reapply Terraform
   ↓
Revalidate
```

The failure must be reversible and must not expose real ePHI.

## Evidence Plan

Phase-specific evidence belongs under:

```text
evidence/phase-02/
```

Evidence should demonstrate:

1. Terraform plan
2. Terraform apply
3. VPC configuration
4. Subnet segmentation
5. Route-table validation
6. Security-group validation
7. VPC Flow Logs
8. Baseline negative-path validation
9. Controlled failure
10. Investigation
11. Remediation
12. Revalidation
13. Terraform destroy
14. Resource-removal verification

## Phase Completion Gate

Phase 2 is complete only when all applicable items are satisfied:

- [ ] Terraform implementation complete
- [ ] `terraform validate` successful
- [ ] `terraform plan` reviewed
- [ ] Infrastructure deployed successfully
- [ ] AWS CLI validation complete
- [ ] Console validation captured where useful
- [ ] Network segmentation validated
- [ ] Controlled failure injected
- [ ] Failure investigated
- [ ] Remediation implemented
- [ ] Remediation revalidated
- [ ] Evidence captured
- [ ] Terraform destroy completed
- [ ] AWS resources verified removed
- [ ] Phase documentation updated
- [ ] Root project README created only at final project completion
- [ ] Git diff reviewed
- [ ] Phase PR created
- [ ] Phase PR reviewed and merged

## Git Strategy

```text
main
  │
  └── phase/02-aws-security-foundation
            │
            ├── implementation
            ├── validation
            ├── failure
            ├── remediation
            ├── evidence
            └── cleanup
                    │
                    ▼
                  PR #2
                    │
                    ▼
                  main
```

Recommended commit sequence:

```text
feat: implement aws network security foundation
test: validate aws network segmentation
test: capture controlled network exposure failure
fix: restore private data-tier network boundary
docs: document phase 2 validation and evidence
```

## Phase 2 Status

**Current status: Planning / implementation preparation.**

No AWS infrastructure should be deployed until the Phase 2 implementation plan and Terraform boundary have been reviewed against the Phase 1 architecture.
