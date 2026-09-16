# Hallazgos de Seguridad

Esta carpeta contiene el material de evaluación de seguridad generado durante el proyecto final.

## Contenido

| Archivo | Descripción |
|---|---|
| `nessus-report.pdf` | Informe original de Nessus |
| `risk-register.md` | Registro técnico de riesgos en inglés |
| `risk-register-ES.md` | Registro técnico de riesgos en español |

## Alcance

Se realizó un único escaneo de Nessus el **19 de agosto de 2026** sobre:

```text
192.168.200.2
192.168.200.100
```

El informe identificó:

```text
0 Critical
0 High
12 Medium
2 Low
134 Informational
```

para un total de 148 findings reportados.

Los 148 findings no se interpretan como 148 vulnerabilidades independientes.

## Limitaciones

La evaluación representa una línea base inicial.

No se realizó un segundo escaneo después de las remediaciones, por lo que el repositorio no afirma que los hallazgos identificados hayan sido posteriormente verificados como corregidos.

## Documentación relacionada

Español:

[07 — Evaluación de Vulnerabilidades](../docs/07-vulnerability-assessment-ES.md)

Inglés:

[07 — Vulnerability Assessment](../docs/07-vulnerability-assessment.md)