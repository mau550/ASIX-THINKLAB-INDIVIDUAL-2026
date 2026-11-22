# T7 · Rendimiento y diagnóstico

| RA | Criterios | Estado |
|---|---|---|
| FDM RA1 | a22 Medir CPU, RAM, disco y red durante las cargas previstas | ✅ |
| FDM RA1 · ISO RA6 | a23 Interpretar las medidas e identificar los recursos saturados | ✅ |
| FDM RA1 | a24 Determinar la capacidad del hardware para ejecutar las VM | ✅ |
| ISO RA6 | a119 Analizar los recursos con diferentes cargas de VM | ✅ |
| ISO RA6 | a120 Determinar cuántas VM se pueden usar sin bloquear el equipo | ✅ |
| ISO RA6 | a121 Informe de medidas y conclusiones | ✅ (este documento) |
| ISO RA6 | a123–a125 (Apte+) Dos optimizaciones aplicadas y comparadas antes/después | ✅ Optimización 1 · ⏳ Optimización 2 (requiere cambiar el SSD de puerto) — ver §5 |

## 1. Método

- **Equipo:** casa (i5-11400F, 16 GB, SSD del laboratorio en USB 2.0). Inventario en [T2](T2-equipos-clase-y-casa.md).
- **Script:** [`scripts/medir-escenario.sh`](../scripts/medir-escenario.sh). Durante 60–120 s toma una muestra cada 5 s con:
  - `vmstat -w 5`: CPU (`us`, `sy`, `id`, `wa`), RAM libre y *swap* (`si`/`so`);
  - `iostat -dxm sda 5`: MB/s, latencia (`r_await`, `w_await`) y `%util` del SSD;
  - `sar -n DEV 5`: tráfico de la tarjeta de red;
  - `pidstat -u -r -C VBoxHeadless`: CPU y RAM real (RSS) de cada VM.
- **Cómo leer las métricas:**
  - CPU saturada si `id` < 10 % de forma sostenida.
  - RAM saturada si `si`/`so` (*swap in/out*) ≠ 0 de forma sostenida o la RAM disponible baja de ~1 GB.
  - Disco saturado si `%util` > 80 % o la latencia (`await`) supera las decenas de ms.

## 2. Escenarios medidos (22/11/2026)

| Escenario | VM encendidas | CPU anfitrión (id) | RAM disponible | Swap (so) | Disco `%util` medio | Ficheros |
|---|---|---|---|---|---|---|
| **E0** | `cli-win11` apagándose (actualizaciones) | 80–85 % libre, `sy` 13–18 % | 6,6 GB | 0 | **80–93 %** (20–40 MB/s) | [vmstat](../anexos/rendimiento/e0-w11-apagado-colgado-vmstat-20261122.txt) · [iostat](../anexos/rendimiento/e0-w11-apagado-colgado-iostat-20261122.txt) |
| **E1** | `cli-linux` (GNOME, login) | 97 % libre | 9,8 GB | 0 | 4 % | [e1](../anexos/rendimiento/e1-debian-20261122.txt) |
| **E2a** | `cli-linux` + `cli-win11` **arrancando** | 89–97 % libre | 5,4 GB | 0 | **42 %** (11,8 MB/s de lectura) | [e2a](../anexos/rendimiento/e2a-arranque-w11-20261122.txt) |
| **E2b** | `cli-linux` + `cli-win11` en reposo | 95 % libre | 5,4 GB | 40 KB/s puntual | 13 % | [e2b](../anexos/rendimiento/e2b-reposo-20261122.txt) |
| **E3** | E2b + **5 GB de carga simulada** (equivale a una 3.ª VM tipo `nas-truenas`/`pve1`) | 89 % libre | **0,76 GB** | **8,3 MB/s** (1,7 GB en swap) | 6 % | [e3](../anexos/rendimiento/e3-carga5g-20261122.txt) |

Consumo real de cada VM (RSS de `VBoxHeadless`): `cli-linux` **1,3 GB** de los 2 GB asignados; `cli-win11` **2,1 GB** de los 4 GB (en reposo).

### Escenario de servidores (sin escritorio)

Con `r-mikrotik` + `r-nftables` + `srv-linux` encendidas, el anfitrión tenía **9,9 GB disponibles**; las tres juntas ocupan unos 2,3 GB reales (RSS 183 + 1212 + 871 MB). Después se añadió `nas-truenas` (8 GB asignados) sin *swap*.

## 3. Interpretación: ¿qué se satura?

1. **El disco, primero.** Basta una sola VM de Windows escribiendo para dejar el SSD al 80–93 %. Con un arranque, el 42 % de media y picos que ralentizan las otras VM. Causa: puerto USB 2.0 → [INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md). Consecuencia extrema: el *reset* del controlador AHCI virtual en `cli-win11` → [INC-003](../incidencias/INC-003-cli-win11-apagado-colgado.md).
2. **La RAM, a partir de la tercera VM grande.** Con dos VM de escritorio quedan 5,4 GB. Al añadir 5 GB el sistema empieza a paginar (8 MB/s de *swap-out*). El **zram** (swap comprimida en RAM, prioridad 100) amortigua el golpe antes de tocar el `/swapfile` del SSD.
3. **La CPU nunca.** 12 hilos frente a 2–4 vCPU activas. Solo hubo `sy` alto (13–18 %) por la E/S de VirtualBox, no por cálculo.
4. **La red nunca.** < 1 Mbit/s en todas las pruebas.

## 4. ¿Cuántas VM puedo usar a la vez sin bloquear el equipo?

Regla: RAM de las VM ≤ RAM física − 4 GB para Linux Mint, y **sin *swap* sostenida**.

| Equipo | RAM para VM | Máximo recomendado | Ejemplo de escenario |
|---|---|---|---|
| 🏠 Casa (16 GB) | ~11 GB | **2 VM de escritorio** o **1 router + TrueNAS + 1–2 servidores sin escritorio** | `r-mikrotik` + `nas-truenas` + `srv-linux` = 9,3 GB ✅ |
| 🏫 Clase (30 GiB) | ~26 GB | **6–8 VM** del diseño | Router + TrueNAS + `pve1-3` = 20–22 GB ✅ (escenario del clúster) |

El clúster Proxmox (3 × 4 GB + NAS 8 GB) **no cabe en el equipo de casa**: se hará en el de clase.

## 5. Optimizaciones (ampliación Apte+)

### Optimización 1 · Servidores sin entorno gráfico ✅ aplicada y medida

| | Antes: Debian con GNOME (`cli-linux`) | Después: Debian sin escritorio (`srv-linux`, `r-nftables`) |
|---|---|---|
| RAM asignada | 2 GB | 1 GB |
| RAM usada **dentro** del invitado (`free -m`) | — | **211 MB** (756 MB disponibles) |
| **RAM real en el anfitrión** (RSS del proceso de la VM) | **1,3 GB** en la pantalla de login | **871 MB** `srv-linux` · 183 MB `r-mikrotik` |
| Arranque (`systemd-analyze`) | GDM en ~60 s | **7,5 s** (4,9 s núcleo + 2,6 s espacio de usuario) |
| Disco ocupado | 7,8 GB | 1,5 GB |

Medidas: [opt1-servidor-sin-escritorio](../anexos/rendimiento/opt1-servidor-sin-escritorio-20261122.txt) · [e1-debian](../anexos/rendimiento/e1-debian-20261122.txt).

**Conclusión:** los servidores no necesitan escritorio. Así caben 4–5 servidores en la RAM que usaría uno con GNOME.

### Optimización 2 · Mover el SSD a un puerto USB 3.x ⏳ pendiente de medir

Es la mejora con más impacto (×10 en disco según el ancho de banda teórico), pero requiere apagar el equipo físico. Procedimiento para completar este apartado:

```bash
lsusb -t | grep -i 'Mass Storage'                 # comprobar 5000M/10000M/20000M
./scripts/pruebas-hardware.sh disco anexos/pruebas-hardware/
./scripts/medir-escenario.sh "E2a-USB3 · cli-linux + cli-win11 arrancando" 120 anexos/rendimiento/e2a-usb3.txt
```

Tabla a rellenar:

| Métrica | USB 2.0 (medido) | USB 3.x |
|---|---|---|
| Lectura secuencial `fio` | 41,0 MiB/s | |
| Escritura secuencial `fio` | 37,9 MiB/s | |
| `%util` del disco en E2a | 42 % | |

## 6. Herramientas de diagnóstico rápido (para la T8)

```bash
free -m                     # ¿queda RAM disponible?
vmstat 5                    # si/so ≠ 0 → falta RAM; wa alto → disco
iostat -xm 5                # %util > 80 % → disco saturado
pidstat -u -r -C VBox 5     # qué VM consume más
VBoxManage list runningvms  # qué hay encendido
```
