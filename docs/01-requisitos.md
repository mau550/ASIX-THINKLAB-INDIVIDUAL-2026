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

**Datos pendientes de definir (N/C):**

El enunciado no establece inicialmente el número de usuarios ni el volumen de datos de la empresa. Por tanto, no se asignarán valores ficticios como si fueran datos reales.

- Número de usuarios: N/C.
- Número de equipos cliente: N/C.
- Volumen total de información: N/C.
- Crecimiento previsto de los datos: N/C.
- Tiempo máximo de recuperación de los servicios: N/C.

La empresa contempla cinco departamentos funcionales: Dirección, Administración, Comercial, Producción e Informática. El número de personas de cada departamento está pendiente de concretar.

## 2. Requisitos del equipo anfitrión

| Recurso | Necesario | Mi equipo individual | Valoración |
|---|---|---|---|
| CPU y virtualización | Procesador de 64 bits y soporte de virtualización; VT-x para virtualización Intel | Intel Core Ultra 5 125H, 14 núcleos físicos y 18 hilos lógicos | Cumple. VT-x disponible. |
| RAM | Memoria suficiente para el anfitrión y las máquinas virtuales activas | 30 GiB | Atención: será necesario distribuir los recursos y trabajar por escenarios. |
| Disco | Espacio suficiente para sistemas, discos virtuales e imágenes | SSD externo de 931,5 GB | Aproximadamente 695 GB disponibles en `/home` según el inventario realizado. |
| Sistema anfitrión | Sistema operativo compatible con el hipervisor | Linux Mint 22.3 | Instalado y operativo. |
| Red | Conectividad para descargar imágenes y actualizar los sistemas | Conectividad del equipo anfitrión | Velocidad y características de la conexión pendientes de comprobar. |
| Firmware | Compatibilidad con los requisitos de arranque de los sistemas invitados | Configuración virtual mediante VirtualBox 7.0.20 | Windows 11 tiene EFI, Secure Boot y TPM 2.0 configurados en su máquina virtual. |
| Virtualización anidada | Necesaria para ejecutar determinados hipervisores dentro de VirtualBox | Intel VT-x disponible; virtualización anidada pendiente de habilitar y verificar | Pendiente de prueba para Proxmox VE. |

**Almacenamiento:** Linux Mint 22.3 está instalado en el SSD externo. El NVMe Samsung interno de aproximadamente 953,9 GB no se utilizará ni modificará en esta fase.

**Limitación principal:** los 30 GiB de RAM disponibles no permiten mantener todas las máquinas virtuales previstas encendidas simultáneamente. Se utilizarán diferentes escenarios de ejecución, asignando recursos según las necesidades de cada prueba.

## 3. Requisitos mínimos oficiales frente a recursos propuestos

La siguiente tabla diferencia los requisitos publicados por los fabricantes de los recursos que se consideran inicialmente para el laboratorio. Los recursos propuestos son orientativos y deberán ajustarse después de comprobar cada instalación.

| Sistema | Requisitos mínimos oficiales | Recursos propuestos para las pruebas | Comentario |
|---|---|---|---|
| MikroTik RouterOS | Dependen de la arquitectura y de la imagen utilizada. Consultar documentación oficial. | Pendiente de dimensionar. | Se estudiará como alternativa de servidor de comunicaciones. |
| OPNsense | CPU x86-64 de doble núcleo y 3 GB de RAM para la especificación mínima indicada en su documentación. | Pendiente de asignar; tomar como referencia inicial 4 GB RAM y disco virtual de 20 GB. | Comprobar los requisitos de la versión elegida y el funcionamiento del instalador. |
| Debian 13 | Los requisitos dependen de la modalidad de instalación y del entorno gráfico. | VM Debian existente: 2 GB RAM, 1 CPU virtual y 20 GB de disco. | Máquina registrada; presenta un problema de arranque pendiente de resolver. |
| TrueNAS SCALE | Procesador x86-64 de dos núcleos, 8 GB RAM, dispositivo de arranque de al menos 16 GB y discos adicionales para almacenamiento. | 8 GB RAM como referencia inicial y discos virtuales adicionales. | Atención: consume una parte importante de la memoria disponible. |
| Proxmox VE | Para evaluación: CPU de 64 bits compatible con VT-x/AMD-V, 1 GB RAM, disco y tarjeta de red, además de la memoria necesaria para las máquinas invitadas. | Pendiente de dimensionar según las pruebas y la virtualización anidada. | La documentación oficial permite su instalación como invitado si el hipervisor admite virtualización anidada. |
| Windows Server 2025 | Consultar requisitos oficiales según modalidad de instalación y funciones del servidor. | Pendiente de asignar; propuesta inicial de 4 GB RAM y 50 GB de disco. | Se estudiará para la gestión centralizada de identidades. |
| Windows 11 | 4 GB RAM, 64 GB de almacenamiento, firmware UEFI, Secure Boot y TPM 2.0. | VM existente: 4 GB RAM, 2 CPU virtuales y 80 GB de disco. | Tiene configurados UEFI, Secure Boot y TPM 2.0 en VirtualBox. Instalación pendiente de verificar. |
| Ubuntu Desktop | Consultar los requisitos oficiales de la versión seleccionada. | Pendiente de dimensionar. | Se estudiará como alternativa de cliente GNU/Linux. |

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
