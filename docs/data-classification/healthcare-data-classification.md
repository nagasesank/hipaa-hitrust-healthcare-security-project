# CareConnect Health Platform Data Classification

## Purpose

Define the technical data-classification model for synthetic healthcare data used by the CareConnect Health Platform and establish storage, access, encryption, logging, and retention expectations.

## Classification Model

| Classification | Meaning | Handling expectation |
| --- | --- | --- |
| `HC-SYN-PHI-HIGH` | Synthetic data representing highly sensitive patient health content | Strict least privilege, strong encryption, minimal logging exposure |
| `HC-SYN-PHI-MED` | Synthetic patient-linked operational data | Protected access, encrypted storage, limited logging |
| `HC-SEC-CONF` | Security-sensitive operational data | Restricted access, encrypted storage, investigation retention |
| `HC-OPS-INT` | Internal operational data | Controlled access, integrity protection |
| `HC-PUBLIC-LAB` | Low-risk public or non-sensitive lab support content | Minimal restrictions relative to other classes |

Real PHI/ePHI is never permitted in this project. All patient-related data is synthetic only.

## Data Categories

| Data category | Classification | Synthetic ePHI for this lab | Primary storage location | Access requirements | Encryption requirements | Logging restrictions | Retention considerations |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Patient ID | HC-SYN-PHI-MED | Yes | Database | Application role and tightly controlled workforce roles only | Encrypt at rest and in transit | Avoid unnecessary duplication in app and security logs | Retain only as required for test scenarios and evidence |
| Patient name | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Do not emit full values into routine logs | Minimize retention in derived artifacts |
| Date of birth | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Redact or omit in logs | Align with synthetic record retention policy |
| Contact information | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Do not include full values in logs | Minimize spread into non-primary systems |
| Insurance ID | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Redact from logs and tickets | Restricted retention and masked display |
| Diagnosis | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Never log full clinical values unless explicitly sanitized for evidence | Retain only within approved synthetic datasets |
| Prescription | HC-SYN-PHI-HIGH | Yes | Database | Application-mediated access only | Encrypt at rest and in transit | Do not expose medication detail in routine telemetry | Retain only as necessary for test cases |
| Clinical notes | HC-SYN-PHI-HIGH | Yes | PHI object storage or database depending object size | Application-mediated access only | Encrypt at rest and in transit with PHI-specific key domain | Exclude free-form content from routine logs | Strict retention and evidence controls |
| Medical records | HC-SYN-PHI-HIGH | Yes | PHI object storage | Application-mediated access only | Encrypt at rest and in transit with dedicated object-storage key domain | Logs may reference protected object IDs only | Retain only for synthetic test scenarios and recovery validation |
| Application logs | HC-SEC-CONF | No, but may reference patient operations | Central application log sink | Security, operations, and investigation roles only | Encrypt at rest and in transit | Must not unnecessarily contain sensitive patient content; use references and correlation IDs | Retention must support audit and investigation needs |
| Security logs | HC-SEC-CONF | No | Central security/audit plane | Security operators and auditors only | Encrypt at rest and in transit with log-specific key domain | Avoid raw patient payloads; allow protected references and actor IDs | Retain to support investigations and evidence |
| Terraform state | HC-OPS-INT | No | Protected state backend in future implementation | Infrastructure administrators only | Encrypt at rest and in transit | Must not store secrets or real PHI; sensitive outputs minimized | Retention aligned to change-control and recovery needs |
| Synthetic test data | Mixed by dataset contents; default HC-SYN-PHI-HIGH if patient-linked | Often yes | Controlled seed data repository and protected runtime stores | Restricted to engineering and validation roles with need-to-know | Encrypt at rest and in transit | Avoid full dataset dumps in logs | Versioned and retained only as required for repeatable testing |

## Additional Handling Requirements

- Sensitive patient information must not be copied into generic debug logs, SIEM annotations, or ticketing systems unless explicitly sanitized.
- Application-level audit logs should reference patient/resource identifiers or protected references rather than dumping full clinical content.
- Backup artifacts inherit the sensitivity of their source data and must be treated as a separate protected boundary.
- Cross-cloud test datasets must remain synthetic and governed by the same classification rules in both AWS and GCP paths.

## OPEN DECISIONS

- Exact retention periods by category remain **OPEN DECISION** pending implementation constraints and evidence storage capacity.
- Exact tokenization/redaction format for patient/resource identifiers in logs remains **OPEN DECISION**.
