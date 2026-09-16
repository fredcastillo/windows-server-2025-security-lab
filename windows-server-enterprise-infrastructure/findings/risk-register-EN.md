# Risk Register — Nessus Assessment

## 1. Scope

A single Nessus scan was performed against the laboratory environment on **August 19, 2026**.

Assessed hosts:

```text
192.168.200.2   → WIN-IORAFMP55C9
192.168.200.100 → ClienteRobles
```

The report was generated on August 19, 2026 at 16:19:39.

---

## 2. Summary

| Host | Critical | High | Medium | Low | Info |
|---|---:|---:|---:|---:|---:|
| 192.168.200.2 | 0 | 0 | 8 | 2 | 100 |
| 192.168.200.100 | 0 | 0 | 4 | 0 | 34 |
| **Total** | **0** | **0** | **12** | **2** | **134** |

The report contains **148 findings** in total. This represents Nessus-reported results and should not be interpreted as 148 independent vulnerabilities.

---

## 3. Register

| ID | Host | Finding | CVSS | Service | Impact / observation | Recommended treatment |
|---|---|---|---:|---|---|---|
| 51192 | 192.168.200.2 | SSL Certificate Cannot Be Trusted | 6.5 | LDAP/LDAPS | Nessus does not trust the presented certificate chain | Review the CA, trust chain and service certificate |
| 45411 | 192.168.200.2 | SSL Certificate with Wrong Hostname | — | LDAP/LDAPS | Nessus identifies a hostname mismatch condition | Review the certificate CN/SAN and service names |
| 104743 | 192.168.200.2 | TLS Version 1.0 Protocol Detection | 6.5 | LDAP/LDAPS | TLS 1.0 remains enabled | Disable TLS 1.0 where compatibility allows |
| 157288 | 192.168.200.2 | TLS Version 1.1 Deprecated Protocol | 6.5 | LDAP/LDAPS | TLS 1.1 remains enabled | Disable TLS 1.1 where possible |
| 10663 | 192.168.200.2 | DHCP Server Detection | 3.3 | UDP/67 | DHCP-related information is exposed | Evaluate whether the exposure is required within the segment |
| 10114 | 192.168.200.2 | ICMP Timestamp Request Remote Date Disclosure | 2.1 | ICMP | System timing information may be disclosed | Evaluate whether ICMP Timestamp responses are required |
| 51192 | 192.168.200.100 | SSL Certificate Cannot Be Trusted | 6.5 | RDP/3389 | RDP certificate is not trusted by Nessus | Review the certificate and CA trust |
| 42873 | 192.168.200.100 | SSL Medium Strength Cipher Suites Supported (SWEET32) | 7.5 | RDP/3389 | Ciphers associated with 3DES are supported | Review and remove legacy ciphers where possible |
| 104743 | 192.168.200.100 | TLS Version 1.0 Protocol Detection | 6.5 | RDP/3389 | TLS 1.0 remains enabled | Disable TLS 1.0 where compatibility allows |
| 157288 | 192.168.200.100 | TLS Version 1.1 Deprecated Protocol | 6.5 | RDP/3389 | TLS 1.1 remains enabled | Disable TLS 1.1 where possible |

The TLS findings were identified on both LDAP/LDAPS services on the server and RDP on the client. The report explicitly shows TLS 1.0 and TLS 1.1 enabled. 
The client also has finding **42873**, associated with SWEET32 and 3DES on RDP/3389.

> **Note:** Nessus reports finding 42873 with `Risk Factor: Medium` and `CVSS v3.0: 7.5`. Both values are preserved exactly as reported by the source.

---

## 4. Root-Cause Grouping

### A. Certificates

```text
51192 — SSL Certificate Cannot Be Trusted
45411 — SSL Certificate with Wrong Hostname
```

These findings relate to certificate trust and certificate identity.

### B. Legacy TLS Protocols

```text
104743 — TLS 1.0
157288 — TLS 1.1
```

Both findings belong to the same technical category: legacy TLS protocol support.

### C. Legacy RDP Ciphers

```text
42873 — SWEET32 / 3DES
```

This finding is specific to RDP on the client. The report identifies `DES-CBC3-SHA` and 3DES.

### D. Information Exposure

```text
10663 — DHCP Server Detection
10114 — ICMP Timestamp
```

These findings relate to information that can be obtained from the network.

---

## 5. Technical Prioritization

For this project's documentation, the findings are grouped into four main technical areas:

```text
Certificates
     ↓
Legacy TLS
     ↓
Legacy RDP Ciphers
     ↓
Information Exposure
```

This avoids presenting every Nessus result as an unrelated issue when multiple findings originate from the same configuration area.

---

## 6. Recommendations

### Certificates

Review the domain certificate infrastructure and verify:

- Trusted CA
- Certificate chain
- Common Name
- Subject Alternative Name
- Names used to access the service

### TLS

Review enabled TLS versions and retire TLS 1.0 and TLS 1.1 where compatibility requirements allow.

### RDP

Review RDP-supported cipher suites and remove legacy ciphers such as 3DES where they are no longer required.

### ICMP Timestamp

Evaluate whether ICMP Timestamp responses are required by the environment.

### DHCP

Because this is an isolated laboratory, evaluate DHCP information exposure within `192.168.200.0/24` and keep the service restricted to the systems that require it.

---

## 7. Limitations

This register has the following limitations:

```text
✓ One scan
✓ Initial baseline assessment
✓ No post-remediation rescan
✓ Findings are not automatically equivalent to independent vulnerabilities
✓ Assessment performed against a laboratory environment
```

Therefore, this document represents an initial assessment rather than a complete production security audit.

---

## 8. Evidence

Original report:

```text
nessus-report.pdf
```

Related documentation:

```text
../docs/07-vulnerability-assessment.md
```