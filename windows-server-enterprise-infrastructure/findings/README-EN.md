# Security Findings

This directory contains the security assessment material produced during the final project.

## Contents

| File | Description |
|---|---|
| `nessus-report.pdf` | Original Nessus assessment report |
| `risk-register.md` | Technical risk register |
| `risk-register-ES.md` | Spanish version of the risk register |

## Assessment Scope

A single Nessus scan was performed on **August 19, 2026** against:

```text
192.168.200.2
192.168.200.100
```

The report identified:

```text
0 Critical
0 High
12 Medium
2 Low
134 Informational
```

for a total of 148 reported findings.

The 148 findings are not interpreted as 148 independent vulnerabilities.

## Limitations

The assessment represents an initial baseline.

No second Nessus scan was performed after remediation, so this repository does not claim that the identified findings were subsequently verified as resolved.

## Related Documentation

English:

[07 — Vulnerability Assessment](../docs/07-vulnerability-assessment.md)

Spanish:

[07 — Evaluación de Vulnerabilidades](../docs/07-vulnerability-assessment-ES.md)