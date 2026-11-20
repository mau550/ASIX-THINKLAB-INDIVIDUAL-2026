# 03 · Sistemas elegidos

**Tasca 5.1** · Selección de sistemas operativos y plataformas para el laboratorio individual.

**Estado:** Sistemas seleccionados y hashes registrados. Implantación progresiva.  
**Fecha de consulta de las fuentes:** 17/11/2026

## Tabla de sistemas

| Función | Sistema y versión | Imagen | Fuente oficial | Licencia | SHA256 |
|---|---|---|---|---|---|
| Comunicaciones (principal) | MikroTik RouterOS 7.24.5 (x86) | `mikrotik-7.24.5.iso` | https://mikrotik.com/download | Propietaria; x86 necesita clave (demo 24 h) | `4bff16b8ee455eb00a0a5f183936fb0ecfd8f2bf3f5ba1ba64773d8375aaec02` |
| Comunicaciones (alternativo) | OPNsense 26.7 | `OPNsense-26.7-dvd-amd64.iso` | https://opnsense.org/download/ | BSD 2-Clause (libre y gratuito) | `1efd5dc9fa12a1f93571183fe5e3823e22e332872de8417fafb5e4e4d48d5dcd` (N/C¹) |
| Comunicaciones (alternativo) | Debian 13.1 + nftables | `debian-13.1.0-amd64-netinst.iso` | https://www.debian.org/distrib/netinst | Libre (DFSG) | `658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3` |
| NAS / copias | TrueNAS SCALE 25.10.7 (Goldeye) | `TrueNAS-SCALE-25.10.7.iso` | https://www.truenas.com/download-truenas-scale/ | Libre (GPL); soporte de pago opcional | `54ce9441ce66966a392e28f63604ca3c2c083d0bec4db7bb5af2f74f7a007c8e` |
| Virtualización | Proxmox VE 9.2-1 | `proxmox-ve_9.2-1.iso` | https://www.proxmox.com/en/downloads | AGPLv3; suscripción opcional para el repositorio *enterprise* | `4e88fe416df9b527624a175f24c9aa07c714d3332afb1ee3dbf3879573ef2c6c` |
| Dominio | Windows Server 2025 Standard Evaluation (26100.1742) | `w2k25.iso` | https://www.microsoft.com/evalcenter/download-windows-server-2025 | Propietaria; evaluación de 180 días | `b73c9688a4b8d165cadc8bf9a52d86d6483b397801b791ffd5e7d1be6cbd5d56` (N/C²) |
| Cliente Windows | Windows 11 Pro 25H2 (26200.6584) | `win11.iso` | https://www.microsoft.com/software-download/windows11 | Propietaria; sin activar en el laboratorio | `5f53774dcadf7f0aea1c6424a937fcfffe79b4d00aea83e17a5c5accd48cd6de` (N/C²) |
| Cliente Linux | Debian 13.1 (GNOME) | `debian-13.1.0-amd64-netinst.iso` | https://www.debian.org/distrib/netinst | Libre (DFSG) | `658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3` |

Resultado completo con los hashes y las URL de los valores oficiales: [`evidencies/logs/sha256-isos.txt`](../evidencies/logs/sha256-isos.txt).

¹ **OPNsense** publica el SHA256 del archivo comprimido (`.iso.bz2`), no de la ISO ya descomprimida. Por tanto, no se puede comparar directamente con el hash de la ISO. Se conserva el valor calculado para futuras comprobaciones.

² **Microsoft** no publica un fichero de sumas SHA256 junto a las ISO de evaluación/consumo de forma estable. Se guarda el hash calculado para poder comprobar en el futuro que la imagen no ha cambiado.

## ¿Por qué verificar el SHA256?

El SHA256 es una huella digital de 64 caracteres que identifica el contenido de un archivo. Si cambia un solo bit de la ISO, el resultado de la huella será diferente.

La comparación de la huella calculada con la publicada por el fabricante permite comprobar la integridad del archivo descargado respecto a la referencia oficial.

Para realizar la comprobación desde Linux se utiliza el siguiente comando:

```bash
sha256sum mikrotik-7.24.5.iso
```

Resultado obtenido:

```text
4bff16b8ee455eb00a0a5f183936fb0ecfd8f2bf3f5ba1ba64773d8375aaec02
```

El valor coincide con el publicado por MikroTik para esa versión de la imagen.

La verificación se ha aplicado a las imágenes seleccionadas, registrando los resultados en el archivo de hashes. En los casos en los que no existe una referencia oficial directamente comparable, se indica N/C para evitar presentar como verificada una comparación que no se ha podido realizar.

## Requisitos mínimos oficiales vs. recursos del laboratorio

La asignación de recursos se ha planteado teniendo en cuenta los requisitos de cada sistema y las características del equipo físico anfitrión.

El ordenador utilizado dispone de un procesador Intel Core Ultra 5 125H, 14 núcleos físicos, 18 hilos lógicos y 30 GiB de memoria RAM. La virtualización se realiza mediante Oracle VirtualBox 7.0.20 sobre Linux Mint 22.3.

| Sistema | Mínimo oficial | Asignado en el laboratorio | Comentario |
|---|---|---|---|
| RouterOS x86 | 64–256 MB RAM | 2 vCPU · 512 MB · 2 GB | Recursos suficientes para las pruebas previstas |
| OPNsense | 2 GB RAM recomendado (mín. 1 GB), 20 GB disco | 2 vCPU · 2 GB · 20 GB | Configuración prevista para las pruebas de comunicaciones |
| Debian 13 con GNOME | 1 GB RAM (2 GB recomendado con escritorio) | SRV: 1 vCPU · 2 GB. CLI: 1 vCPU · 4 GB | El servidor puede funcionar sin escritorio gráfico |
| TrueNAS SCALE | **8 GB RAM**, 16 GB disco de arranque | 2 vCPU · 4 GB · 32 GB + 2 × 20 GB | Por debajo del mínimo recomendado; uso limitado a pruebas controladas |
| Proxmox VE | 2 GB RAM (más la de las VMs), CPU con VT-x | 4 vCPU · 6 GB · 20 GB, *nested VT-x* | Virtualización anidada pendiente de activar y verificar |
| Windows Server 2025 | 512 MB (Core) / **2 GB con escritorio**, 32 GB disco, UEFI + TPM 2.0 recomendados | 2 vCPU · 4 GB · 50 GB · EFI · TPM 2.0 | Configuración prevista con escritorio para gestionarlo mediante interfaz gráfica |
| Windows 11 | **4 GB RAM, 64 GB disco, UEFI + Secure Boot, TPM 2.0** | 2 vCPU · 4 GB · 80 GB · EFI · TPM 2.0 | Cumple los requisitos de RAM y almacenamiento previstos |

**Consideraciones sobre los recursos:**

- Los recursos previstos no significan que todos los sistemas estén ya instalados.
- El equipo dispone de 30 GiB de RAM física, por lo que será necesario controlar la memoria asignada y reservar recursos para Linux Mint.
- TrueNAS SCALE se probará con una asignación de RAM inferior a la recomendada oficialmente. Esta limitación se tendrá en cuenta al interpretar los resultados.
- La virtualización anidada necesaria para Proxmox VE está pendiente de comprobación.
- La ejecución simultánea de todas las máquinas virtuales no está prevista; se realizarán las pruebas por escenarios.

## Firmware y arranque (Tasca 5.2)

La configuración del firmware virtual se ha seleccionado según los requisitos de arranque de cada sistema operativo.

| VM | Firmware | Motivo |
|---|---|---|
| Windows Server 2025 / Windows 11 | **UEFI + TPM 2.0** | Configuración prevista para Windows Server 2025 y Windows 11. Windows 11 requiere UEFI, Secure Boot y TPM 2.0 |
| MikroTik, OPNsense, Debian, TrueNAS, Proxmox | BIOS | Configuración prevista para facilitar la instalación en VirtualBox, siempre que la versión del sistema lo permita |

### Configuración actual de las máquinas virtuales

En el entorno individual se encuentran registradas dos máquinas virtuales:

| VM | Firmware | Controlador gráfico | Memoria de vídeo | TPM 2.0 | Secure Boot |
|---|---|---|---:|---|---|
| Debian 13.1 | BIOS | VMSVGA | 128 MB | No configurado | No configurado |
| W11 | EFI | VBoxSVGA | 128 MB | Configurado | Configurado |

La máquina virtual Debian 13.1 utiliza firmware BIOS y tiene pendiente resolver un problema de arranque. La máquina W11 tiene configurados EFI, TPM 2.0 y Secure Boot; la instalación del sistema operativo está pendiente de verificar.

Las configuraciones de los sistemas restantes se comprobarán durante su creación.

## Valoración final

La selección de sistemas permite disponer de diferentes plataformas para estudiar las comunicaciones, la seguridad, el almacenamiento, la virtualización y la administración de equipos y usuarios.

La configuración del equipo anfitrión permite desarrollar estas pruebas mediante máquinas virtuales, siempre que se distribuya adecuadamente la memoria y el procesador disponibles.

La implantación se realizará progresivamente, comprobando el funcionamiento de cada sistema y documentando las incidencias que puedan aparecer durante las instalaciones y configuraciones.
