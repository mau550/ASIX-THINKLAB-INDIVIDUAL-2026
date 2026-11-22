# 01 · Requisitos

## 1. Necesidades del entorno individual

El objetivo es reproducir en mi equipo individual una parte de la infraestructura informática de la empresa planteada en el proyecto. La adaptación dependerá de los recursos físicos disponibles, por lo que no será necesario ejecutar todos los servicios y máquinas virtuales simultáneamente.

Las necesidades principales identificadas son las siguientes:

| Necesidad | Pregunta del enunciado | Solución propuesta para mi laboratorio |
|---|---|---|
| **Comunicaciones** | ¿Cómo conectamos y filtramos las redes? | Estudio de MikroTik RouterOS, OPNsense y Debian con nftables para disponer de diferentes alternativas de encaminamiento y cortafuegos. |
| **Virtualización** | ¿Qué recursos y nodos necesita el laboratorio? | VirtualBox 7.0.20 como plataforma individual y Proxmox VE como sistema de virtualización que se estudiará. |
| **Gestión centralizada** | ¿Qué servicio administra usuarios y equipos? | Windows Server 2025 con Active Directory Domain Services (AD DS) y DNS. |
| **Clientes** | ¿Qué sistemas permiten trabajar a los diferentes departamentos? | Windows 11 y GNU/Linux, con Ubuntu y Debian como alternativas. |
| **Datos** | ¿Cómo organizamos y compartimos los archivos? | Estudio de TrueNAS para almacenamiento centralizado y recursos compartidos. |
| **Recuperación** | ¿Cómo recuperamos la información ante un fallo? | Copias de seguridad de configuraciones, archivos y máquinas virtuales, junto con el control de versiones mediante Git. |
| **Supervisión** | ¿Cómo detectamos problemas de funcionamiento? | Registros del sistema, `journalctl`, `vmstat`, `iostat` y herramientas de diagnóstico. |

**Datos que el enunciado no fija (N/C):**

El enunciado no establece el número de usuarios ni el volumen de datos de la empresa. Por tanto, no se asignarán valores ficticios como si fueran datos reales.

- Número de usuarios: N/C.
- Número de equipos cliente: N/C.
- Volumen total de información: N/C.
- Crecimiento previsto de los datos: N/C.
- Tiempo máximo de recuperación de los servicios: N/C.

La empresa contempla cinco departamentos funcionales: Dirección, Administración, Comercial, Producción e Informática. El enunciado no fija cuántas personas hay en cada uno; en el laboratorio se crearon en el dominio una OU, un grupo y usuarios de ejemplo por departamento ([srv-dc](../maquinas/srv-dc/README.md)), suficientes para probar permisos y políticas sin inventar una plantilla real.

## 2. Requisitos del equipo anfitrión

| Recurso | Necesario | Mi equipo individual | Valoración |
|---|---|---|---|
| CPU y virtualización | Procesador de 64 bits y soporte de virtualización; VT-x para virtualización Intel | Clase: Core Ultra 5 125H (14 núcleos / 18 hilos). Casa: Core i5-11400F (6 / 12) | Cumple en los dos. VT-x + EPT; virtualización anidada activada en `pve1-3` |
| RAM | Memoria suficiente para el anfitrión y las máquinas virtuales activas | Clase: 30 GiB · Casa: 16 GB | ⚠️ Limita, sobre todo en casa: se trabaja por escenarios ([T7](T7-rendimiento.md)) |
| Disco | Espacio suficiente y velocidad para sistemas, discos virtuales e imágenes | SSD externo USB de 931,5 GB (común a los dos equipos) | 689 GB libres en `/home` (22/11). ⚠️ En casa está en un puerto USB 2.0 → 41 MB/s ([INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md)) |
| Sistema anfitrión | Sistema operativo compatible con el hipervisor | Linux Mint 22.3 | Instalado y operativo. |
| Red | Conectividad para descargar imágenes y actualizar los sistemas | Casa: Ethernet Gigabit | ✅ Medido: 456 Mbit/s de descarga y 10 ms a Internet ([T2](T2-equipos-clase-y-casa.md)) |
| Firmware | Compatibilidad con los requisitos de arranque de los sistemas invitados | Configuración virtual mediante VirtualBox 7.0.20 | `cli-win11` arranca con UEFI y TPM 2.0 virtual; `srv-dc` y `r-opnsense` con UEFI. |
| Virtualización anidada | Necesaria para ejecutar determinados hipervisores dentro de VirtualBox | Activada en `pve1`, `pve2` y `pve3` (`--nested-hw-virt on`) | ✅ Comprobada: Proxmox ejecuta la VM KVM 101 dentro de VirtualBox ([pve1](../maquinas/pve1/README.md)) |

**Almacenamiento:** Linux Mint 22.3 está instalado en el SSD externo. Los discos internos (NVMe Samsung de 953,9 GB en clase y 970 EVO Plus de 500 GB en casa) no se usan ni se modifican.

> **Corrección:** la versión anterior solo recogía el equipo de clase. El entorno funciona en **dos equipos** con el mismo SSD USB ([T2](T2-equipos-clase-y-casa.md)).

**Limitación principal:** ni los 30 GiB del equipo de clase ni los 16 GB del de casa permiten mantener todas las máquinas virtuales previstas encendidas simultáneamente. Se utilizarán diferentes escenarios de ejecución, asignando recursos según las necesidades de cada prueba.

## 3. Requisitos mínimos oficiales frente a recursos propuestos

La siguiente tabla diferencia los requisitos publicados por los fabricantes de los recursos **finalmente asignados** en el laboratorio (22/11/2026, tras instalar y probar cada sistema).

| Sistema | Requisitos mínimos oficiales | Recursos asignados (VirtualBox) | Comentario |
|---|---|---|---|
| MikroTik RouterOS | Dependen de la arquitectura y de la imagen utilizada. Consultar documentación oficial. | `r-mikrotik` (CHR 7.24.5): **256 MB RAM, 1 CPU, disco de 128 MB** | ✅ Router principal; la imagen CHR para x86 es mínima ([r-mikrotik](../maquinas/r-mikrotik/README.md)) |
| OPNsense | CPU x86-64 de doble núcleo y 3 GB de RAM para la especificación mínima indicada en su documentación. | `r-opnsense` (26.7.9): **2 GB RAM, 2 CPU, 20 GB** | ✅ Con 2 GB, por debajo del mínimo oficial de 3 GB, funcionó bien en las pruebas (cortafuegos, NAT, DHCP, actualización a 26.7.9); para activar IDS/IPS o proxy convendría subir a 4 GB ([r-opnsense](../maquinas/r-opnsense/README.md)) |
| Debian 13 | Los requisitos dependen de la modalidad de instalación y del entorno gráfico. | `cli-linux`: 2 GB, 1 CPU, 20 GB (escritorio) · `srv-linux`: 1 GB, 1 CPU, 10 GB + 4×1 GB RAID · `r-nftables`: 1 GB, 1 CPU, 8 GB | ✅ El problema de arranque de `cli-linux` se resolvió ([INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md)); los servidores van sin escritorio |
| TrueNAS SCALE | Procesador x86-64 de dos núcleos, 8 GB RAM, dispositivo de arranque de al menos 16 GB y discos adicionales para almacenamiento. | `nas-truenas` (25.10.7): **4 GB RAM, 2 CPU, 20 GB sistema + 20 GB datos** | ✅ Con 4 GB funciona para copias (sin apps ni deduplicación); se enciende solo cuando hace falta |
| Proxmox VE | Para evaluación: CPU de 64 bits compatible con VT-x/AMD-V, 1 GB RAM, disco y tarjeta de red, además de la memoria necesaria para las máquinas invitadas. | `pve1-3` (9.2): **2 GB RAM, 2 CPU, 32 GB** cada nodo, virtualización anidada | ✅ Clúster de 3 nodos con un CT y una VM Debian pequeños | La documentación oficial permite su instalación como invitado si el hipervisor admite virtualización anidada. |
| Windows Server 2025 | Consultar requisitos oficiales según modalidad de instalación y funciones del servidor. | `srv-dc` (2025 Standard con escritorio): **4 GB RAM, 2 CPU, 50 GB** | ✅ Controlador del dominio `iso29.lan` con DNS ([srv-dc](../maquinas/srv-dc/README.md)) |
| Windows 11 | 4 GB RAM, 64 GB de almacenamiento, firmware UEFI, Secure Boot y TPM 2.0. | `cli-win11`: **4 GB RAM, 2 CPU, 64 GB**, UEFI + TPM 2.0 | Reinstalada el 22/11: 4 GB RAM, 2 CPU, 64 GB, UEFI + TPM 2.0 (Secure Boot compatible, no activado). Windows 11 Pro 23H2 verificado ([cli-win11](../maquinas/cli-win11/README.md)). |
| Ubuntu Desktop | Consultar los requisitos oficiales de la versión seleccionada. | No instalado | Descartado: con Debian 13 en `cli-linux` ya se cubre el cliente GNU/Linux y se ahorran ~4 GB de RAM |

**Fuentes oficiales de requisitos:**

- OPNsense: https://docs.opnsense.org/manual/hardware.html
- Debian: https://www.debian.org/releases/
- TrueNAS: https://www.truenas.com/docs/scale/25.10/gettingstarted/scalehardwareguide/
- Proxmox VE: https://www.proxmox.com/en/products/proxmox-virtual-environment/requirements
- Windows Server: https://learn.microsoft.com/windows-server/get-started/hardware-requirements
- Windows 11: https://www.microsoft.com/windows/windows-11-specifications
- MikroTik: https://help.mikrotik.com/docs/

Fecha de consulta de las fuentes: **20/11/2026**.

Las versiones definitivas, las licencias, las condiciones de soporte y las comprobaciones de las imágenes se ampliarán en el documento de estudio de sistemas.

## 4. Requisitos de seguridad y documentación

- Las credenciales y contraseñas de administración permanecerán **fuera del repositorio GitHub**. No se publicarán archivos con información sensible.
- Antes de modificar una configuración de red o una regla de cortafuegos se conservará una copia del estado anterior para poder recuperar la configuración.
- Las pruebas de red se realizarán en redes virtuales controladas, evitando interferir en la red compartida del aula.
- Se diferenciará la conexión NAT de la red interna utilizada para las comunicaciones entre máquinas virtuales.
- Las imágenes de instalación se obtendrán de las páginas oficiales de los fabricantes o proyectos.
- Se registrarán las versiones utilizadas, los recursos asignados y los problemas encontrados.
- Las instalaciones y configuraciones se verificarán antes de considerarlas finalizadas.
- La documentación se realizará en Markdown, se controlará mediante Git y se publicará en el repositorio personal de GitHub.
