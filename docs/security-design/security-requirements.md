# CareConnect Health Platform Security Requirements

## Purpose

Define the technical security requirements for the CareConnect Health Platform before implementation.

## Identity and MFA

- Workforce and administrative access must use federated identity.
- MFA is mandatory for workforce, security, backup, and infrastructure administrators.
- Human identities and workload identities must remain separate.
- Privileged roles must not be shared across unrelated operational domains.
- Break-glass access, if introduced later, must be tightly controlled and audited.

## IAM

- Access must follow least privilege.
- Human identities receive role-based access aligned to duties.
- Workload identities receive only the permissions required for their service responsibilities.
- Security, backup, and application roles must be separated.
- Cross-cloud credentials must not be broadly reusable across AWS and GCP.

## Authorization

- Patient-level authorization is enforced in the application layer, not delegated solely to cloud IAM.
- Admin APIs require stronger authorization boundaries than patient APIs.
- Object- and record-level access decisions must prevent IDOR and VIP snooping patterns.
- Access decisions must be auditable with correlation IDs and outcome state.

## Network Segmentation

- Edge, application, data, security, backup, and management planes must remain logically segmented.
- Data stores must not be publicly reachable.
- Direct internet access to database and PHI object storage is prohibited.
- East-west access paths must be explicitly justified.

## Ingress

- All user ingress must traverse the edge load-balancing and WAF layer.
- Edge protections must support request filtering, abuse resistance, and request telemetry.
- No direct administrative management path should share the same exposure model as patient traffic.

## Egress

- Outbound access from the application tier must be minimized.
- Egress paths to security, logging, backup, and secret retrieval services must be explicitly defined.
- Arbitrary outbound data transfer from ePHI-handling components is prohibited by default.

## Encryption

- Synthetic ePHI, logs, backups, and secrets must be encrypted at rest.
- All sensitive data flows must be encrypted in transit.
- Encryption domains must be separated by data type and operational purpose.

## KMS

- Logical key boundaries are required for:
  - PHI/object storage
  - database
  - logs/audit
  - backups
  - secrets
- Key administrators must be separated from key users.
- KMS authorization failures must be detectable and investigable.
- One universal environment key is prohibited.

## Secrets

- Secrets must be stored in a dedicated secret-management service.
- Secrets must not be hardcoded into source, Terraform, or logs.
- Secret access must be restricted to the minimum required workload or operator identities.
- Rotation strategy remains an **OPEN DECISION** until implementation details are approved.

## Application Security

- Patient and admin APIs must use explicit authentication and authorization boundaries.
- The application tier must emit structured patient access audit events.
- Logs must avoid unnecessary sensitive patient content.
- Correlation IDs must be used across requests, audit events, and investigations.
- Synthetic ePHI must never be exposed through debugging shortcuts or uncontrolled exports.

## WAF

- WAF protections must cover common web attack patterns and obvious abuse paths.
- WAF logs must support validation of prevent/detect scenarios.
- WAF is a defense-in-depth control and not a substitute for application authorization.

## Audit Logging

- Infrastructure audit logging is mandatory.
- Application-level patient access auditing is mandatory.
- Logging must support attribution of actor, action, target, result, and time.
- Security-sensitive logs must be protected from routine modification and deletion.

## Application-Level Patient Auditing

Every patient/resource access event must conceptually capture:

- actor identity
- actor role
- patient/resource identifier or protected reference
- operation
- purpose of use where applicable
- timestamp
- request/correlation ID
- result/outcome

CloudTrail or equivalent cloud-native logs must not be treated as sufficient for this requirement.

## Monitoring

- Monitoring must cover edge, application, identity, data, backup, and security planes.
- Failed authentication, authorization failures, KMS failures, unusual data access, and drift conditions must be observable.
- Backup success and restore success must be monitored.

## Detection

- Detection coverage must exist for credential misuse, over-privilege, storage exposure, unusual access patterns, logging failures, and configuration drift.
- Security findings must route into a response-ready telemetry path.
- GCP and AWS detections must satisfy equivalent objectives even when services differ.

## Backup

- Backups are a separate security boundary.
- Backup access must be restricted from ordinary production operators.
- Backup data must use backup-specific encryption controls.
- Retention and deletion protection are mandatory design requirements.
- Recovery testing is mandatory.

## Recovery

- Recovery workflows must validate database and object-storage restoration.
- Recovery operations must be auditable.
- Recovery evidence must be captured for future implementation phases.

## Configuration Compliance

- Desired-state infrastructure is intended to be governed by Terraform after design approval.
- Drift detection and configuration compliance signals are required.
- Out-of-band change detection must be visible to the security/audit plane.

## Incident Response

- Security events must route into an investigation and response path.
- Response plans must support credential compromise, logging failure, public exposure, exfiltration, deletion, drift, and cross-cloud abuse scenarios.
- Incident response design must preserve evidence required for root-cause analysis and remediation validation.

## Evidence

- Each future phase must collect validation evidence, failure-injection evidence, investigation evidence, remediation evidence, and destroy/removal evidence.
- Evidence must include both application-level and cloud-level artifacts where applicable.

## Mandatory Engineering Method

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

## OPEN DECISIONS

- Exact compute runtime on AWS and GCP
- Exact database engine selection
- Exact secret rotation cadence
- Exact backup retention windows
- Exact session-abuse mitigations beyond MFA baseline
