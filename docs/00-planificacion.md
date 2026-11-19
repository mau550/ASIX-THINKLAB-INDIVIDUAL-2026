# TAREA 0. PLANIFICACIÓN DEL ENTORNO DE PRUEBAS INDIVIDUAL

## 1. Introducción

El objetivo de esta tarea es preparar un entorno de pruebas individual que permita realizar las instalaciones, configuraciones y comprobaciones necesarias durante el desarrollo del proyecto ASIX ThinkLab.

Se tomará como referencia la infraestructura planteada para el trabajo en grupo, adaptándola a los recursos físicos disponibles en mi equipo personal.

La planificación contempla la creación de once máquinas virtuales destinadas a representar los diferentes servicios y departamentos de la infraestructura informática.

## 2. Equipo físico disponible

El entorno individual se realizará sobre un único equipo físico con las siguientes características:

- Sistema operativo anfitrión: Linux Mint 22.3.
- Procesador: Intel Core Ultra 5 125H.
- Memoria RAM: 30 GB aproximadamente.
- Almacenamiento principal: SSD externo de 931,5 GB.
- Virtualización: Oracle VirtualBox 7.0.20.
- Tecnología de virtualización: Intel VT-x.

La asignación de recursos a las máquinas virtuales se adaptará a las posibilidades del equipo, evitando ejecutar simultáneamente todas las máquinas cuando la memoria o el procesador puedan verse comprometidos.

## 3. Máquinas virtuales previstas

El entorno individual contempla las siguientes máquinas virtuales:

1. MikroTik RouterOS CHR.
2. OPNsense.
3. Debian GNU/Linux con nftables.
4. TrueNAS.
5. Proxmox VE 1.
6. Proxmox VE 2.
7. Proxmox VE 3.
8. Windows Server 2025.
9. Debian GNU/Linux para infraestructura y RAID.
10. Windows 11.
11. Ubuntu Desktop.

La configuración definitiva de cada máquina se establecerá teniendo en cuenta los requisitos del sistema operativo, los servicios que deberá proporcionar y los recursos disponibles.

## 4. Planificación del montaje

El montaje del entorno se realizará de forma progresiva, siguiendo este orden:

- Preparación del equipo anfitrión y comprobación de los recursos disponibles.
- Revisión de la configuración de VirtualBox.
- Creación y configuración de las máquinas virtuales.
- Instalación de los sistemas operativos correspondientes.
- Configuración de las redes virtuales y comunicación entre máquinas.
- Configuración de los servicios de infraestructura.
- Preparación de los sistemas de almacenamiento y pruebas RAID.
- Realización de comprobaciones de funcionamiento y rendimiento.

## 5. Organización y documentación

La documentación del proyecto se realizará utilizando Markdown, Git y GitHub.

Se registrarán las características del equipo físico, las máquinas virtuales creadas, los recursos asignados, los esquemas de red, las configuraciones realizadas y las evidencias de las pruebas.

También se documentarán los problemas encontrados durante el montaje y las soluciones aplicadas.

## 6. Adaptación a los recursos disponibles

Debido a que el entorno individual se ejecutará sobre un único equipo físico, será necesario adaptar la infraestructura de clase.

No se prevé arrancar todas las máquinas virtuales simultáneamente. Se organizarán diferentes escenarios de trabajo según las necesidades de cada actividad.

Esta planificación permitirá aprovechar los recursos disponibles y evitar una sobrecarga del equipo anfitrión.

## 7. Estado de la planificación

La planificación inicial ha sido revisada y aprobada por el profesor.

El montaje, la instalación y la configuración del entorno se desarrollarán progresivamente durante las siguientes tareas del proyecto.
