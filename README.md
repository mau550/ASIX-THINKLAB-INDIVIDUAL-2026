# ASIX ThinkLab — Naix un sistema

**Proyecto individual de instalación, configuración y supervisión de sistemas.**

- **Alumno:** Mauro Bas Montes
- **Repositorio:** ASIX-THINKLAB-INDIVIDUAL-2026
- **Sistema anfitrión:** Linux Mint 22.3
- **Virtualización:** Oracle VirtualBox 7.0.20
- **Procesador:** Intel Core Ultra 5 125H
- **Memoria RAM:** 30 GiB

## Descripción

Este repositorio recoge el desarrollo individual del proyecto ASIX ThinkLab. El objetivo es diseñar, montar y documentar un entorno de pruebas para estudiar sistemas operativos, virtualización, comunicaciones, almacenamiento, recuperación y rendimiento.

## Entorno de pruebas

El laboratorio se ejecuta sobre un equipo con Linux Mint y VirtualBox. La arquitectura contempla servidores de infraestructura, comunicaciones, almacenamiento y equipos cliente.

## Máquinas virtuales

| Máquina | Función | Estado |
|---|---|---|
| Debian 13.1 | Servidor Linux e infraestructura | Registrada en VirtualBox |
| Windows 11 | Equipo cliente | Registrada en VirtualBox |
| Resto de máquinas | Servicios y clientes del laboratorio | Definidas en el diseño |

## Documentación

| Tarea | Contenido | Documento |
|---|---|---|
| 0 | Planificación del entorno de pruebas | [00-planificacion.md](docs/00-planificacion.md) |
| 1 | Necesidades y sistemas | En preparación |
| 2 | Equipos y periféricos | Por desarrollar |
| 3 y siguientes | Instalación, configuración y pruebas | Por desarrollar |

## Estructura del repositorio

- `docs/`: documentación técnica.
- `diagramas/`: esquemas de arquitectura y red.
- `configuraciones/`: archivos de configuración.
- `evidencias/`: capturas y resultados de las pruebas.
- `scripts/`: scripts de administración y automatización.
- `Proyecto-por-Tareas/`: organización complementaria del trabajo.
- `entrega/`: material preparado para la entrega.

## Seguimiento

La documentación se actualiza mediante Git y se publica en GitHub. Las configuraciones y resultados se incorporan conforme se realizan y verifican las prácticas.
