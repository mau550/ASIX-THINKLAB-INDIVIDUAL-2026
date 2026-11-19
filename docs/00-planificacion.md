# ASIX ThinkLab
# Tarea 0 · Mi entorno de pruebas

**Preparación y documentación del entorno individual de virtualización**

| Dato | Entorno individual |
|---|---|
| Sistema anfitrión | Linux Mint 22.3 |
| Hipervisor | Oracle VirtualBox 7.0.20 |
| Equipo | Un único ordenador físico |
| Almacenamiento principal | SSD externo de 931,5 GB |
| Fecha | 19 de noviembre de 2026 |

---

## 1. Finalidad y alcance

El objetivo de esta tarea es preparar un entorno individual de pruebas que permita realizar las instalaciones y configuraciones previstas en el proyecto ASIX ThinkLab. El entorno debe reproducir de forma aproximada el montaje del grupo y adaptarse a los recursos del equipo disponible. No es necesario que sea idéntico ni que todas las máquinas virtuales puedan funcionar simultáneamente.

La ampliación Apte+ solicita documentar el montaje en Markdown y publicarlo en un repositorio Git personal. La memoria debe incluir el esquema de máquinas virtuales, los recursos asignados y los problemas encontrados junto con sus soluciones.

## 2. Características del equipo

El entorno individual se ejecuta en un único ordenador físico con Linux Mint 22.3. Los datos siguientes corresponden a la información recopilada durante las sesiones de trabajo; las características del equipo y la configuración de partida quedan recogidas en esta memoria.

| Componente | Característica |
|---|---|
| Sistema operativo | Linux Mint 22.3 |
| Procesador | Intel Core Ultra 5 125H |
| CPU | 14 núcleos físicos y 18 procesadores lógicos |
| Memoria RAM | Aproximadamente 30 GiB |
| Memoria swap | Aproximadamente 15 GiB |
| Disco externo | SSD portátil de 931,5 GB; contiene Linux Mint y el directorio personal |
| Disco interno | NVMe Samsung de 953,9 GB; no se utiliza ni se modifica para este montaje |
| Hipervisor | Oracle VirtualBox 7.0.20 |

Linux Mint está instalado en el SSD externo. Este disco es necesario para iniciar el sistema y trabajar con las máquinas virtuales. El NVMe interno queda fuera del alcance de este montaje y no se modificará.

## 3. Criterios de diseño y limitaciones

La memoria RAM es el principal condicionante. La configuración de referencia de las once máquinas suma aproximadamente 37,25 GB si se conserva la Debian existente con 2 GB de RAM. Esta cantidad supera la memoria física del equipo y no incluye la que necesita Linux Mint. Por ello, las máquinas se organizarán en escenarios y solo se iniciarán las necesarias para cada práctica.

Los tres nodos Proxmox se ejecutarán como máquinas virtuales dentro de VirtualBox. Esta virtualización anidada permite practicar conceptos de clúster y migración, aunque su rendimiento será inferior al de un clúster instalado directamente sobre equipos físicos.

Cuando sea posible, los discos virtuales se configurarán como dinámicos. Su capacidad máxima no equivale necesariamente al espacio ocupado: el archivo crece a medida que se guardan datos. Será necesario controlar el espacio libre del SSD externo.

## 4. Diseño de las máquinas virtuales

Se ha tomado como referencia un inventario de once máquinas. Las versiones que aparecen a continuación proceden de la configuración de referencia facilitada para el proyecto y deberán comprobarse antes de cada instalación. La tabla recoge la arquitectura de referencia del laboratorio y la situación comprobada de las máquinas disponibles.

| N.º | Nombre | Función / sistema de referencia | CPU | RAM | Disco y estado individual |
|---:|---|---|---:|---:|---|
| 1 | `r-mikrotik` | Router · MikroTik RouterOS CHR 7.24.6 | 1 | 256 MB | Imagen CHR. Incluida en el diseño del laboratorio. |
| 2 | `r-opnsense` | Router · OPNsense 26.7.9 | 2 | 2 GB | 20 GB. Incluida en el diseño del laboratorio. |
| 3 | `r-nftables` | Router · Debian 13.7 + nftables, sin escritorio | 1 | 1 GB | 8 GB. Incluida en el diseño del laboratorio. |
| 4 | `nas-truenas` | NAS · TrueNAS Community 25.10.8 | 2 | 8 GB | 20 GB sistema + 20 GB datos. Incluida en el diseño del laboratorio. |
| 5 | `pve1` | Nodo de virtualización · Proxmox VE 9.2 | 2 | 4 GB | 32 GB. Incluida en el diseño del laboratorio. |
| 6 | `pve2` | Nodo de virtualización · Proxmox VE 9.2 | 2 | 4 GB | 32 GB. Incluida en el diseño del laboratorio. |
| 7 | `pve3` | Nodo de virtualización · Proxmox VE 9.2 | 2 | 4 GB | 32 GB. Incluida en el diseño del laboratorio. |
| 8 | `srv-dc` | Servidor de dominio · Windows Server 2025 Evaluation | 2 | 4 GB | 50 GB. Incluida en el diseño del laboratorio. |
| 9 | `srv-linux` | Servidor Linux y RAID · Debian | 1 | 2 GB | Debian 13.1 existente; disco 20 GB. Seleccionada para su adaptación como servidor Linux. |
| 10 | `cli-win11` | Cliente Windows · Windows 11 Pro | 2 | 4 GB | W11 existente; disco 80 GB. Configuración registrada; la instalación del sistema invitado no se da por comprobada. |
| 11 | `cli-linux` | Cliente Linux · Ubuntu Desktop 26.04.1 LTS | 4 | 4 GB | 25 GB. Incluida en el diseño del laboratorio. |

El inventario define las once máquinas que componen el laboratorio individual. En VirtualBox se encuentran registradas Debian 13.1 y Windows 11; el resto queda especificado con sus recursos y función para mantener una arquitectura coherente con las prácticas del proyecto.

### 4.1. Máquinas existentes

**Debian 13.1.** Tiene 1 vCPU, 2 GB de RAM, un disco VDI dinámico de 20 GB y red NAT. En una prueba anterior mostró una pantalla negra al arrancar; la causa no está determinada. Su función dentro del laboratorio queda definida como servidor Linux para las prácticas de infraestructura y RAID, condicionada a la resolución de este problema de arranque.

**Windows 11 (W11).** Tiene 2 vCPU, 4 GB de RAM y un disco VDI dinámico de 80 GB. Tiene configurados EFI, TPM 2.0 y Secure Boot, y utiliza red NAT. La ISO está identificada en el directorio de descargas. La máquina queda definida como cliente Windows del laboratorio; el estado de instalación del sistema invitado no se considera verificado.

## 5. Organización de la red

La propuesta consiste en utilizar una red NAT de VirtualBox para la conectividad exterior y una red interna para las comunicaciones entre las máquinas del laboratorio. El router virtual actuará como enlace entre ambas. Las tres alternativas de router (MikroTik CHR, OPNsense y Debian con nftables) se probarán por separado; no se prevé utilizarlas simultáneamente como pasarela principal.

El diseño de red queda establecido mediante NAT para la conectividad exterior y una red interna para las comunicaciones del laboratorio. No se consignan direcciones IP ni reglas concretas que no hayan sido configuradas y comprobadas.

### Esquema lógico previsto

```text
RED EXTERIOR
NAT de VirtualBox
       |
       v
ROUTER VIRTUAL SELECCIONADO
MikroTik CHR / OPNsense / Debian con nftables
       |
       v
RED INTERNA DEL LABORATORIO
Comunicación entre las máquinas virtuales
       |
       +-----------------------------+
       |                             |
       v                             v
SERVICIOS                       CLIENTES
TrueNAS                         Windows 11
Windows Server                  Ubuntu Desktop
Debian de infraestructura
Nodos Proxmox
```

El esquema recoge la arquitectura lógica definida para el laboratorio. Las direcciones y reglas específicas se documentarán en las evidencias de configuración de red.

## 6. Escenarios de trabajo

Como la memoria disponible no permite ejecutar todas las máquinas a la vez, se propone dividir las prácticas en escenarios. Las cifras son estimaciones basadas en la RAM asignada, no mediciones de consumo real. En todos los casos hay que reservar memoria para el sistema anfitrión.

| Escenario | Máquinas previstas | RAM aproximada |
|---|---|---:|
| Comunicaciones | Un router + TrueNAS + Ubuntu Desktop | Hasta 13 GB con un router de 1 GB; hasta 14 GB con OPNsense |
| Clúster y migración | Un router + TrueNAS + pve1 + pve2 + pve3 | Hasta 22 GB con OPNsense |
| Dominio y clientes | Un router + TrueNAS + Windows Server + Windows 11 + Ubuntu | Hasta 22 GB con OPNsense |
| Servidor y RAID | Un router + TrueNAS + Debian de infraestructura | Hasta 12 GB con OPNsense |

La organización por escenarios permite adaptar el número de máquinas activas a la memoria disponible. Las cifras indicadas son estimaciones de RAM asignada y no mediciones de consumo real.

## 7. Comparación con el entorno del grupo

| Elemento | Entorno del grupo (referencia) | Entorno individual |
|---|---|---|
| Equipamiento | Varios equipos físicos y servidor central | Un ordenador con Linux Mint y VirtualBox |
| Router | MikroTik físico y otras soluciones | Routers virtuales; una alternativa activa cada vez |
| LAN | Conmutadores físicos | Red interna de VirtualBox |
| NAS | TrueNAS físico con discos dedicados | TrueNAS virtualizado con discos virtuales |
| Proxmox | Nodos sobre el servidor del centro | Tres nodos virtualizados dentro de VirtualBox |
| Clientes | Ordenadores físicos del aula | VM Windows 11 y Ubuntu Desktop |

La diferencia principal es que en el entorno individual CPU, memoria y almacenamiento dependen de un solo equipo. Por ello, es necesario planificar las sesiones y limitar las máquinas que se ejecutan simultáneamente.

## 8. Incidencias conocidas

| Incidencia | Estado actual y actuación prevista |
|---|---|
| Debian 13.1 muestra pantalla negra | Incidencia detectada. La causa no está confirmada; se diagnosticará antes de adaptar la VM. |
| Instalación de Windows 11 | No verificada. Hay que comprobar el arranque y completar la instalación si procede. |
| Memoria insuficiente para todas las VM | Limitación prevista por el cálculo de RAM. Se trabajará por escenarios. |
| Virtualización anidada en Proxmox | Pendiente de configurar y comprobar cuando se creen los tres nodos. |

Las incidencias quedan identificadas y documentadas con su estado comprobado. No se atribuyen soluciones que todavía no se han ejecutado ni verificado.

## 9. Documentación y publicación

El repositorio personal de GitHub `ASIX-THINKLAB-INDIVIDUAL-2026` está creado y el repositorio Git local está inicializado. La rama principal es `main` y ya se ha publicado un primer documento de planificación. Esta memoria constituye el documento Markdown de la Tarea 0 y se acompaña de su versión PDF.

Las evidencias se organizarán por temas: hardware, VirtualBox, red, sistemas, RAID y rendimiento. Las evidencias se organizan por temas y recogen configuraciones y resultados reales, evitando incluir contraseñas, tokens o datos privados.

## 10. Conclusión

El diseño propuesto adapta las funciones principales del laboratorio del grupo a un equipo individual con Linux Mint 22.3 y VirtualBox. Se han identificado las limitaciones principales, especialmente la memoria RAM y la ejecución de Proxmox mediante virtualización anidada. La planificación conserva las once funciones de referencia y aprovecha dos máquinas que ya están registradas en VirtualBox.

La memoria deja documentado el diseño del entorno individual, los recursos asignados, la organización de red y las incidencias detectadas. El documento diferencia expresamente el diseño técnico de las instalaciones y comprobaciones efectivamente realizadas.

## Referencia del enunciado

ASIX ThinkLab, documento del proyecto, versión 2.0 (19/10/2026), apartado «Tasca 0. Muntatge de l’entorn de proves a l’aula», página 5. El enunciado solicita preparar un entorno individual adaptado al equipo disponible y, para la ampliación Apte+, documentarlo en Markdown y publicarlo en un repositorio Git personal, incluyendo el esquema de las máquinas, los recursos asignados y las incidencias con sus soluciones.
