# CareConnect Health Platform ePHI Data Flow

## Purpose

Document the principal synthetic ePHI data flows, related identities, trust boundaries, and required audit and telemetry paths for CareConnect Health Platform.

## Flow Overview

This phase documents logical data movement only. It does not assert any deployed implementation.

## Trust Boundaries

| Boundary ID | Boundary | What crosses it | Identities crossing | Data crossing | Primary protections | Logging / evidence |
| --- | --- | --- | --- | --- | --- | --- |
| TB-01 | Internet | User requests and responses | Patient/User, workforce browser/client | API requests, authenticated sessions, TLS traffic | TLS, edge filtering, authentication, rate limiting | Edge logs, WAF logs, request correlation IDs |
| TB-02 | Edge/WAF | Sanitized ingress from edge to API layer | Edge service identity to application entry point | API requests, headers, request metadata | WAF, ingress policy, request validation | WAF findings, load balancer logs |
| TB-03 | Application tier | Business logic processing and service-to-service calls | Patient API identity, Admin API identity | Authorized request context, application events | Private compute boundary, app authz, workload IAM | App logs, app audit events, trace IDs |
| TB-04 | PHI data tier | Data access from application to database/object storage | Application workload identities | Synthetic ePHI records and object reads/writes | Private networking, data-store authz, KMS, least privilege | DB audit signals where available, object access logs, app audit events |
| TB-05 | Security/audit plane | Telemetry and findings ingestion | Application, cloud services, security tools | App audit events, infra logs, security findings | Restricted log destinations, encryption, access separation | Central security logs, finding aggregation, event history |
| TB-06 | Backup/recovery plane | Backup creation and restore operations | Backup identities, restore operators | Backup data, restore metadata | Separate access model, backup encryption, deletion protection | Backup job logs, restore test evidence |
| TB-07 | Identity plane | Authentication and token/claim exchange | Workforce users, admin users, app trust relationships | IdP tokens, MFA state, identity claims | Federated auth, MFA, session controls | Identity provider audit logs, admin access evidence |
| TB-08 | CI/CD and infrastructure-management plane | Planned infra changes and deployment authority | Infrastructure admins, CI/CD identity | Source changes, state changes, deployment metadata | Least privilege, secret separation, change control | Change logs, code review evidence, future pipeline logs |
| TB-09 | AWS/GCP cloud boundary | Cross-cloud design equivalence and operator management | Cross-cloud admin/security roles only | Metadata, evidence, investigation context | Credential separation, blast-radius isolation, independent logging | Cloud-specific audit trails, review evidence |

## Patient Access Flow

1. Patient initiates a request from TB-01.
2. Request enters TB-02 through the edge/WAF layer.
3. Request is routed to the patient API in TB-03.
4. Patient API validates session and application authorization.
5. Application reads or writes synthetic ePHI from TB-04.
6. Application returns a sanitized response through TB-02 back to TB-01.
7. Application emits patient access audit events into TB-05.

Required audit attributes:

- actor identity
- actor role
- patient/resource identifier or protected reference
- operation
- purpose of use where applicable
- timestamp
- correlation/request ID
- result/outcome

## Workforce / Admin Flow

1. Workforce user authenticates through TB-07 with MFA.
2. Authenticated request crosses TB-01 and TB-02 into the admin API.
3. Admin API enforces stricter authorization than patient flows.
4. Admin actions affecting synthetic ePHI or security-relevant configuration generate application and security events.
5. Administrative actions must be traceable in both app-level and infrastructure-level audit paths.

## API to Database Flow

- Origin: private application tier in TB-03
- Destination: database in TB-04
- Data: structured synthetic ePHI and metadata
- Identity: application workload identity only
- Controls: private connectivity, least privilege, KMS-backed encryption, query authorization
- Evidence: application trace IDs, DB access signals where available, security telemetry

## API to Object Storage Flow

- Origin: private application tier in TB-03
- Destination: PHI object storage in TB-04
- Data: synthetic medical records, attachments, and generated objects
- Identity: application workload identity only
- Controls: bucket/object access restrictions, KMS-backed encryption, no public access
- Evidence: object access logs, app audit events, correlation IDs

## KMS Interaction Flow

- Database encryption path uses a database-specific key domain.
- Object storage encryption path uses a PHI-object key domain.
- Log destinations use a log/audit-specific key domain.
- Backup artifacts use a backup-specific key domain.
- Secret storage uses a secret-specific key domain.

Key principles:

- Key administration is separate from key usage.
- Losing decrypt permission for an application role is an intentional failure scenario and must result in observable access failure.
- KMS use should be visible through cloud audit trails and application symptoms.

## Application Audit-Log Flow

1. Application authorizes or rejects an operation.
2. Application emits a patient access audit event with actor, target, operation, purpose, timestamp, correlation ID, and outcome.
3. Audit event is forwarded to the security/audit plane.
4. Security tooling correlates the event with infrastructure telemetry when required.

Application audit flow is mandatory because CloudTrail and equivalent infrastructure logs cannot provide patient-level access intent and business context on their own.

## Infrastructure Audit-Log Flow

1. Cloud control-plane and security services emit audit and finding data.
2. Telemetry is centralized into the security/audit plane.
3. Event routing forwards notable findings toward incident-response workflows.
4. Evidence is captured for validation, investigation, and remediation records.

## Backup Flow

1. Protected backup identities create backups from database and object-storage sources.
2. Backups are encrypted under separate backup key domains.
3. Backup metadata and restore activity are recorded in the security/audit plane.
4. Restore testing produces validation evidence and recovery timing records.

## Security Telemetry Flow

Sources:

- application audit events
- infrastructure audit logs
- configuration-compliance signals
- threat-detection findings
- network flow visibility
- backup/restore activity

Destination:

- central security/audit plane
- event-routing path for incident response
- evidence repository references

## AWS / GCP Boundary

The design requires equivalent security objectives across AWS and GCP, but not identical services or workflows. Data flow patterns remain conceptually aligned:

- authenticated ingress
- private application processing
- private ePHI storage
- distinct encryption boundaries
- centralized telemetry
- isolated backup and recovery

## OPEN DECISIONS

- Exact correlation format between application audit events and cloud-native logs is **OPEN DECISION**.
- Exact log pipeline aggregation tooling and schema normalization across AWS and GCP is **OPEN DECISION**.
