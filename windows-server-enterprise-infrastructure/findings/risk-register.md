# Registro de Riesgos — Evaluación Nessus

## 1. Alcance

Se realizó un único escaneo de Nessus sobre la red de laboratorio el **19 de agosto de 2026**.

Hosts evaluados:

```text
192.168.200.2  → WIN-IORAFMP55C9
192.168.200.100 → ClienteRobles
```

El informe fue generado el 19 de agosto de 2026 a las 16:19:39.

---

## 2. Resumen

| Host | Critical | High | Medium | Low | Info |
|---|---:|---:|---:|---:|---:|
| 192.168.200.2 | 0 | 0 | 8 | 2 | 100 |
| 192.168.200.100 | 0 | 0 | 4 | 0 | 34 |
| **Total** | **0** | **0** | **12** | **2** | **134** |

El informe contiene **148 findings** en total. Esta cifra corresponde a resultados reportados por Nessus y no debe interpretarse como 148 vulnerabilidades independientes.

---

## 3. Registro

| ID | Host | Hallazgo | CVSS | Servicio | Impacto / observación | Tratamiento recomendado |
|---|---|---|---:|---|---|---|
| 51192 | 192.168.200.2 | SSL Certificate Cannot Be Trusted | 6.5 | LDAP/LDAPS | Nessus no confía en la cadena del certificado presentado | Revisar CA, cadena de confianza y certificado utilizado |
| 45411 | 192.168.200.2 | SSL Certificate with Wrong Hostname | — | LDAP/LDAPS | El certificado presentado no coincide adecuadamente con la identidad del servicio según Nessus | Revisar CN/SAN y nombres utilizados por el servicio |
| 104743 | 192.168.200.2 | TLS Version 1.0 Protocol Detection | 6.5 | LDAP/LDAPS | TLS 1.0 permanece habilitado | Deshabilitar TLS 1.0 cuando la compatibilidad lo permita |
| 157288 | 192.168.200.2 | TLS Version 1.1 Deprecated Protocol | 6.5 | LDAP/LDAPS | TLS 1.1 permanece habilitado | Deshabilitar TLS 1.1 cuando sea posible |
| 10663 | 192.168.200.2 | DHCP Server Detection | 3.3 | UDP/67 | Expone información relacionada con el servicio DHCP | Evaluar si dicha exposición es necesaria dentro del segmento |
| 10114 | 192.168.200.2 | ICMP Timestamp Request Remote Date Disclosure | 2.1 | ICMP | Permite obtener información temporal del sistema | Evaluar si las respuestas ICMP Timestamp son necesarias |
| 51192 | 192.168.200.100 | SSL Certificate Cannot Be Trusted | 6.5 | RDP/3389 | El certificado de RDP no es considerado confiable por Nessus | Revisar certificado y confianza de la CA |
| 42873 | 192.168.200.100 | SSL Medium Strength Cipher Suites Supported (SWEET32) | 7.5 | RDP/3389 | Se detectó soporte para cifrados asociados con 3DES | Revisar y retirar cifrados heredados cuando sea posible |
| 104743 | 192.168.200.100 | TLS Version 1.0 Protocol Detection | 6.5 | RDP/3389 | TLS 1.0 permanece habilitado | Deshabilitar TLS 1.0 cuando la compatibilidad lo permita |
| 157288 | 192.168.200.100 | TLS Version 1.1 Deprecated Protocol | 6.5 | RDP/3389 | TLS 1.1 permanece habilitado | Deshabilitar TLS 1.1 cuando sea posible |

Los cuatro hallazgos TLS aparecen tanto en servicios LDAP/LDAPS del servidor como en RDP del cliente. El informe identifica específicamente TLS 1.0 y TLS 1.1 como habilitados. 
El cliente también presenta el finding **42873**, asociado con SWEET32 y 3DES en RDP/3389.

> **Nota:** Nessus reporta el finding 42873 con `Risk Factor: Medium` y `CVSS v3.0: 7.5`. Ambos valores se conservan tal como aparecen en el informe.

---

## 4. Agrupación por causa técnica

### A. Certificados

```text
51192 — SSL Certificate Cannot Be Trusted
45411 — SSL Certificate with Wrong Hostname
```

Estos hallazgos apuntan a la configuración de certificados y su correspondencia/confianza.

### B. Protocolos TLS antiguos

```text
104743 — TLS 1.0
157288 — TLS 1.1
```

Ambos hallazgos aparecen en más de un servicio y representan una misma categoría técnica: uso de versiones antiguas de TLS.

### C. Cifrados heredados en RDP

```text
42873 — SWEET32 / 3DES
```

Este hallazgo se relaciona específicamente con RDP en el cliente. El reporte identifica `DES-CBC3-SHA` y 3DES.

### D. Exposición de información

```text
10663 — DHCP Server Detection
10114 — ICMP Timestamp
```

Estos resultados están relacionados con información que puede obtenerse desde la red.

---

## 5. Priorización técnica

Para el análisis documental del proyecto, los findings se agrupan en cuatro áreas principales:

```text
Certificados
     ↓
TLS heredado
     ↓
Cifrados heredados en RDP
     ↓
Exposición de información
```

Esta agrupación evita presentar cada resultado como un problema independiente cuando varios pertenecen al mismo origen técnico.

---

## 6. Recomendaciones

### Certificados

Revisar la infraestructura de certificados del dominio y verificar:

- CA de confianza
- cadena de certificación
- CN
- Subject Alternative Name
- nombres utilizados para acceder al servicio

### TLS

Revisar las versiones de TLS habilitadas y retirar TLS 1.0 y TLS 1.1 cuando los requisitos de compatibilidad del entorno lo permitan.

### RDP

Revisar los cifrados admitidos por RDP y retirar cifrados heredados como 3DES cuando ya no sean necesarios.

### ICMP Timestamp

Evaluar si las respuestas ICMP Timestamp son necesarias para el funcionamiento del entorno.

### DHCP

Debido a que este es un laboratorio aislado, evaluar la exposición del servicio dentro del segmento `192.168.200.0/24` y mantenerlo restringido al entorno que realmente lo necesita.

---

## 7. Limitaciones

Este registro tiene las siguientes limitaciones:

```text
✓ Un único escaneo
✓ Evaluación inicial / baseline
✓ Sin re-scan después de las remediaciones
✓ Los findings no equivalen automáticamente a vulnerabilidades independientes
✓ El entorno evaluado es un laboratorio
```

Por tanto, este documento representa una evaluación inicial y no una auditoría completa de producción.

---

## 8. Evidencia

Informe original:

```text
nessus-report.pdf
```

Documentación relacionada:

```text
../docs/07-vulnerability-assessment-ES.md
```