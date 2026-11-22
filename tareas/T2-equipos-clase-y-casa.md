# T2 · Equipos y periféricos: equipo de clase frente a equipo de casa

| RA | Criterios de la rúbrica | Estado |
|---|---|---|
| FDM RA1 | a19 Inventariar el equipo de clase y el de casa | ✅ Hecho |
| FDM RA1 | a20 Comparar los equipos e identificar cuellos de botella | ✅ Hecho |
| FDM RA1 | a21 Proponer soluciones ajustadas al hardware disponible | ✅ Hecho |
| FDM RA1 | a27–a29 (Apte+) Tests de memoria, disco y red; registrar herramienta, condiciones y resultados; confirmar o descartar con datos los cuellos de botella | ✅ En el equipo de casa · ⏳ En el de clase (falta ejecutar el script en el aula) |

> **Corrección respecto a la versión anterior:** en la T0 y en el inventario anterior figuraba un único ordenador (Core Ultra 5 125H, 30 GiB). En realidad trabajo con **dos equipos** y un **SSD portátil USB** que llevo de uno a otro. Ese SSD contiene Linux Mint 22.3 y todas las VM, así que el entorno es el mismo en los dos sitios.

## 1. Inventario

Datos obtenidos con `hostnamectl`, `lscpu`, `free -h`, `swapon`, `lsblk`, `lspci`, `lsusb -t`, `ip`, `sensors` y `mokutil`. Salidas completas:
[equipo de casa](../anexos/hardware/equipo-casa-i5-11400F-20261122.txt) · [equipo de clase](../anexos/hardware/equipo-clase-ultra5-125H-20261119.txt).

| Componente | 🏫 Equipo de clase (portátil) | 🏠 Equipo de casa (sobremesa) |
|---|---|---|
| Tipo / placa | Portátil del centro | Sobremesa · Gigabyte **H510M H** (BIOS FA, 11/11/2021) |
| CPU | Intel **Core Ultra 5 125H** (Meteor Lake) | Intel **Core i5-11400F** (Rocket Lake) |
| Núcleos / hilos | 14 núcleos (4P + 8E + 2LPE) / **18 hilos** | 6 núcleos / **12 hilos** |
| Frecuencia máx. | 4,5 GHz | 4,4 GHz (medida bajo carga: 4,2 GHz en todos los núcleos) |
| Caché L3 | 18 MiB | 12 MiB |
| Virtualización | VT-x + EPT | VT-x + EPT (`vmx`, `ept` en `lscpu`) |
| RAM | **30 GiB** | **15,5 GiB** (16 GB) |
| Swap | 15 GiB (zram 7,6 GiB + fichero) | 11,9 GiB (zram 3,9 GiB prio 100 + `/swapfile` 8 GiB) |
| Disco interno | NVMe Samsung MZVMA1T0HCLD 953,9 GB (no se usa) | NVMe Samsung 970 EVO Plus 500 GB, NTFS (Windows de casa, no se usa) |
| **Disco del laboratorio** | SanDisk Portable SSD 931,5 GB por USB | El mismo SanDisk Portable SSD, **conectado a USB 2.0 (480 Mbit/s)** |
| Gráfica | Integrada Intel Arc | NVIDIA GeForce GTX 1650 (driver `nouveau`) |
| Red | Wi-Fi / Ethernet del aula | Realtek RTL8111 Gigabit, enlace **1000 Mb/s full duplex** |
| Firmware | UEFI | UEFI, Secure Boot **desactivado** |
| Periféricos | Teclado y touchpad integrados | Teclado y ratón USB (1,5 Mbit/s), auriculares Logitech USB, grabadora DVD SATA |

### Particiones del SSD portátil (común a los dos equipos)

| Partición | Tamaño | Sistema de ficheros | Montaje | Uso (22/11) |
|---|---|---|---|---|
| `sda1` | 509 MB | vfat | `/boot/efi` | Arranque UEFI |
| `sda2` | 122,6 GB | ext4 | `/` | 23 GB usados / 92 GB libres |
| `sda3` | 808,4 GB | ext4 | `/home` | 66 GB usados / **689 GB libres** (VM e ISO) |

## 2. Cuellos de botella previstos

| # | Recurso | Por qué podría limitar | Equipo afectado |
|---|---|---|---|
| 1 | **RAM** | Las 11 VM del diseño suman ~37 GB asignados | Sobre todo **casa** (16 GB) |
| 2 | **Disco USB** | Todas las VM leen y escriben en el mismo SSD externo | Los dos; depende del puerto |
| 3 | CPU | 21 vCPU en total si se encendiera todo | Poco probable: nunca van todas a la vez |
| 4 | Red | Descarga de ISO y actualizaciones | Poco probable |

## 3. Pruebas (ampliación Apte+) — equipo de casa

**Condiciones:** 22/11/2026, todas las VM apagadas, sesión gráfica abierta, gobernador de CPU `powersave` (el de serie). Script reproducible: [`scripts/pruebas-hardware.sh`](../scripts/pruebas-hardware.sh).

### 3.1 Disco — `fio` 3.36, fichero de 1 GiB en `/home`, `--direct=1` (sin caché), `iodepth=16`

| Prueba | Resultado | Latencia |
|---|---|---|
| Escritura secuencial 1 MiB | **37,9 MiB/s** | media 420 ms |
| Lectura secuencial 1 MiB | **41,0 MiB/s** | media 390 ms |
| Lectura aleatoria 4 KiB | 6652 IOPS (26,0 MiB/s) | media 2,4 ms |
| Escritura aleatoria 4 KiB | 5716 IOPS (22,3 MiB/s) | media 2,8 ms |

[Salida completa](../anexos/pruebas-hardware/casa-disco-fio-20261122.txt)

### 3.2 Memoria — `stress-ng` 0.17.06

| Prueba | Resultado |
|---|---|
| `--vm 2 --vm-bytes 3G --vm-method all --verify -t 60s` (6 GB escritos y **verificados**) | `passed: 2`, `failed: 0` → **sin errores de memoria** |
| `--memrate` (ancho de banda, 512 MB) | ~16,3 GB/s escritura 64 bit · ~15,8 GB/s `memset` |

[Salida completa](../anexos/pruebas-hardware/casa-memoria-cpu-20261122.txt)

### 3.3 CPU y temperatura — `stress-ng --cpu 12 --cpu-method matrixprod -t 60s`

| Momento | Temperatura del paquete | Frecuencia media |
|---|---|---|
| Reposo | 48 °C | — |
| A los 50 s de carga al 100 % | **75 °C** (límite 100 °C) | **4200 MHz** |

Resultado: `passed: 12, failed: 0`. No hay *thermal throttling*: la refrigeración es suficiente.

### 3.4 Red

| Prueba | Herramienta | Resultado |
|---|---|---|
| Enlace | `/sys/class/net/enp3s0/speed` | 1000 Mb/s full duplex |
| Latencia al router de casa | `ping -c 20 192.168.1.1` | 0,56 ms de media, 0 % pérdidas |
| Latencia a Internet | `ping -c 20 1.1.1.1` | 10,2 ms, 0 % pérdidas |
| Ruta | `tracepath -n 1.1.1.1` | 8 saltos, MTU 1492 (PPPoE del operador) |
| Descarga real | `curl` de la ISO netinst de Debian (20 s máx.) | 795 MB en 13,9 s = **57 MB/s ≈ 456 Mbit/s** |

[Salida completa](../anexos/pruebas-hardware/casa-red-20261122.txt)

## 4. Cuellos de botella: confirmados o descartados con datos

| # | Previsto | Veredicto | Dato que lo demuestra |
|---|---|---|---|
| 2 | Disco USB | ✅ **CONFIRMADO (casa)** | `lsusb -t` → `Mass Storage … 480M`; `fio` 41 MiB/s, techo del USB 2.0. Con una sola VM, `iostat` marca el disco al 80–93 % → [INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md) |
| 1 | RAM | ✅ **CONFIRMADO (casa)** a partir de la 3.ª VM | Con `cli-linux` + `cli-win11` quedan 5,4 GB disponibles; al añadir 5 GB más, el sistema hace *swap-out* de ~8 MB/s y quedan 0,76 GB libres ([T7](T7-rendimiento.md)) |
| 3 | CPU | ❌ **DESCARTADO** | Con 2 VM, la CPU del anfitrión está al 95–97 % libre; a plena carga, 4,2 GHz sin calentarse |
| 4 | Red | ❌ **DESCARTADO** | 456 Mbit/s y 10 ms: las descargas las limita el disco (40 MB/s), no la red |

## 5. Soluciones ajustadas al hardware que tengo

| Problema | Solución | Coste | Estado |
|---|---|---|---|
| SSD en USB 2.0 (casa) | Conectarlo a un puerto **USB 3.2** trasero de la H510M H | 0 € | Propuesta (el SSD es el disco de arranque; se aplica con el equipo apagado, ver [T7](T7-rendimiento.md)) |
| 16 GB de RAM en casa | Trabajar **por escenarios**, con un solo router encendido; los servidores Linux **sin escritorio** (1 GB); `nas-truenas` solo cuando haga falta copiar | 0 € | ✅ Aplicado |
| 16 GB de RAM en casa | Ampliar a 32 GB (la H510M H admite 2 × 32 GB DDR4) | ~60 € | Propuesta |
| Escenarios grandes (clúster Proxmox) | Hacerlos en el **portátil de clase** (30 GiB) | 0 € | ✅ Planificado |

## 6. Pendiente en el equipo de clase

Ejecutar en el aula, con las VM apagadas, y subir las salidas a `anexos/pruebas-hardware/`:

```bash
./scripts/pruebas-hardware.sh todo anexos/pruebas-hardware/
```
