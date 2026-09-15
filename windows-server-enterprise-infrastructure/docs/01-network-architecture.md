# 01 — Arquitectura de Red

## Contexto

El proyecto requería una infraestructura funcional basada en Windows Server capaz de proporcionar servicios de **Active Directory, DNS y DHCP** a clientes Windows unidos al dominio.

La implementación final utilizó dos interfaces de red en el servidor Windows:

- Una interfaz conectada mediante modo **Bridged** a la red física.
- Una segunda interfaz conectada a una red **Host-only** de VMware para el laboratorio interno.

Esta separación permitió mantener el entorno interno del proyecto en una subred privada mientras el servidor conservaba conectividad con la red física cuando era necesario.

---

## Diseño de red

La configuración final utilizó dos redes IPv4 diferentes.

### Red física

```text
Red: 192.168.100.0/24
Gateway: 192.168.100.1
```

La interfaz original del servidor utilizó:

```text
Interfaz: Ethernet0
IP: 192.168.100.147
Máscara: 255.255.255.0
Gateway: 192.168.100.1
```

Esta interfaz permaneció conectada a la red física mediante VMware Bridged.

### Red del laboratorio

Se agregó una segunda interfaz al servidor y se conectó a **VMware VMnet2**, configurada como red Host-only.

```text
Red: 192.168.200.0/24
IP del servidor: 192.168.200.2/24
Gateway: Ninguno
```

Esta red fue utilizada como segmento aislado para el laboratorio.

```text
                     Red física
                   192.168.100.0/24
                           │
                           │ Ethernet0
                           │ 192.168.100.147
                  ┌────────▼─────────┐
                  │ Windows Server   │
                  │ WIN-IORAFMP55C9  │
                  │                  │
                  │ AD DS / DNS      │
                  │ DHCP             │
                  └────────┬─────────┘
                           │
                           │ Ethernet1
                           │ 192.168.200.2
                           │
                    ┌──────▼───────┐
                    │ VMware VMnet2│
                    │ Host-only     │
                    │ 192.168.200.0│
                    │      /24     │
                    └──────┬───────┘
                           │
                           │ DHCP
                           ▼
                  ┌────────────────┐
                  │ ClienteRobles  │
                  │ 192.168.200.100│
                  └────────────────┘
```

---

## Configuración de VMware VMnet2

La red interna utilizó el modo **Host-only** de VMware.

```text
VMnet2
Subred: 192.168.200.0/24
```

El adaptador virtual del host permaneció habilitado.

Durante la configuración se encontró un conflicto con la dirección `.1`, ya que VMware utilizaba esa dirección dentro de la red virtual.

Por esta razón, el controlador de dominio terminó utilizando:

```text
192.168.200.2
```

en lugar de `.1`.

Esta dirección se convirtió en el punto estable para los servicios internos de DNS y DHCP.

---

## Configuración de red del Domain Controller

### Ethernet0

```text
IP: 192.168.100.147
Máscara: 255.255.255.0
Gateway: 192.168.100.1
DNS: 127.0.0.1
```

### Ethernet1

```text
IP: 192.168.200.2
Máscara: 255.255.255.0
Gateway: Ninguno
DNS: 192.168.200.2
```

La segunda interfaz fue utilizada para el laboratorio interno y el servicio DHCP.

---

## Implementación de DHCP

DHCP fue instalado y autorizado en Active Directory.

El ámbito utilizado fue:

```text
Nombre: Laboratorio-VMnet2
Red: 192.168.200.0/24
Rango: 192.168.200.100 - 192.168.200.200
```

Las principales opciones configuradas fueron:

```text
Servidor DNS: 192.168.200.2
Dominio DNS: fred.castillo
```

La duración de la concesión permaneció en el valor predeterminado de ocho días.

No se configuró la opción de gateway dentro del ámbito, ya que esta red fue diseñada como un entorno aislado y no necesitaba utilizar el Domain Controller como router hacia Internet.

---

## Configuración del cliente Windows

El cliente del laboratorio utilizó:

```text
Nombre: ClienteRobles
```

El cliente fue trasladado de la red Bridged a VMware VMnet2.

La interfaz se configuró para utilizar DHCP mediante:

```powershell
Set-NetIPInterface -Dhcp Enabled
ipconfig /release
ipconfig /renew
```

Después del cambio, el cliente conservó inicialmente la configuración DNS anterior:

```text
192.168.100.147
```

Esto provocó problemas de resolución del dominio porque el cliente se encontraba ahora en la red `192.168.200.0/24`.

La configuración DNS se restableció mediante:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ResetServerAddresses
```

Después de la corrección, el cliente obtuvo su configuración de red desde el DHCP interno.

---

## Validación

El cliente obtuvo correctamente una dirección del ámbito DHCP.

La configuración esperada fue:

```text
IP del cliente: 192.168.200.100
DNS: 192.168.200.2
Dominio DNS: fred.castillo
```

La detección del controlador de dominio se verificó con:

```cmd
nltest /dsgetdc:fred.castillo
```

La resolución DNS se validó mediante:

```cmd
nslookup fred.castillo
```

Estas pruebas confirmaron que el cliente podía localizar el Domain Controller y resolver el dominio mediante el DNS interno.

---

## Problemas y diagnóstico

### Problema 1 — Conflicto con la dirección de VMnet2

La primera intención fue utilizar:

```text
192.168.200.1
```

pero esta dirección estaba siendo utilizada dentro de la red virtual de VMware.

La dirección definitiva del Domain Controller quedó en:

```text
192.168.200.2
```

---

### Problema 2 — DNS anterior en el cliente

Después de mover el cliente a VMnet2, este recibió una dirección DHCP de la nueva subred, pero todavía conservaba la configuración DNS anterior.

El cliente continuaba utilizando:

```text
192.168.100.147
```

como DNS.

El restablecimiento de la configuración DNS permitió que el cliente utilizara correctamente:

```text
192.168.200.2
```

---

## Consideraciones de seguridad

El uso de una red Host-only dedicada permitió aislar el tráfico interno del laboratorio de la red física.

El diseño también evitó exponer directamente el tráfico DHCP y las comunicaciones internas del cliente a la red física.

El Domain Controller utilizó una dirección estática en la red interna para mantener una dirección estable para servicios como DNS, DHCP y Active Directory.

---

## Evidencia

Las capturas previstas para este documento serán almacenadas en:

```text
../../assets/01-network/
```

Archivos sugeridos:

```text
01-network-adapter-configuration.png
02-vmnet2-configuration.png
03-dhcp-scope.png
04-client-dhcp-address.png
05-domain-validation.png
```

Las imágenes deberán proceder de la evidencia real del proyecto, principalmente las capturas originales o frames extraídos del video de demostración.

---

## Resultado

La implementación final proporcionó:

```text
✓ Dirección estable para el Domain Controller
✓ Red de laboratorio aislada
✓ Servicio DHCP
✓ Resolución DNS interna
✓ Detección del Domain Controller
✓ Conectividad del cliente Windows
✓ Direccionamiento DHCP para el cliente
```

Esta arquitectura sirvió como base para los demás componentes del proyecto.