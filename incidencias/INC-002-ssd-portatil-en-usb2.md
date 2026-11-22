# INC-002 · El SSD portátil del laboratorio funciona a velocidad USB 2.0 en el equipo de casa

> **Estado: DIAGNOSTICADA y mitigada** (optimizaciones de la [T7](../tareas/T7-rendimiento.md)); solución definitiva propuesta: cambiar de puerto. Tipo: incidencia de **hardware / rendimiento** (FDM RA1, ISO RA6).
> Equipo: casa (Gigabyte H510M H · i5-11400F) · Dispositivo: SanDisk Portable SSD 931,5 GB (`sda`)

## 1. Síntoma

- Las VM tardan mucho en arrancar y en apagarse.
- Al apagar `cli-win11`, Windows se quedó colgado en pantalla negra y el registro de VirtualBox mostró:

  ```text
  00:11:04.719408 AHCI#0: Port 0 reset
  00:11:04.769736 VD#0: Cancelling all active requests
  ```

  El controlador SATA virtual se reinició porque el disco no respondía a tiempo (ver [INC-003](INC-003-cli-win11-apagado-colgado.md)).

## 2. Diagnóstico

| Prueba | Comando | Resultado | Interpretación |
|---|---|---|---|
| Velocidad del enlace USB | `lsusb -t` · `cat /sys/bus/usb/devices/1-9/speed` | `Port 009: Dev 005, Class=Mass Storage, Driver=uas, 480M` · `speed=480`, `version=2.10` | El SSD está en el **bus 001 (USB 2.0, 480 Mbit/s)**. La placa tiene un bus 002 a **20000M (USB 3.2 Gen 2x2)** que no se está usando |
| Lectura secuencial | `fio --rw=read --bs=1M --direct=1` | **41,0 MiB/s** | Techo práctico del USB 2.0 (≈ 40 MB/s). Un SSD por USB 3.x debería dar 400–1000 MB/s |
| Escritura secuencial | `fio --rw=write --bs=1M` | **37,9 MiB/s**, latencia media 420 ms | Igual: limitada por el bus |
| Aleatorio 4K | `fio --rw=randread/randwrite --bs=4k --iodepth=16` | 6652 / 5716 IOPS | Aceptable; el bus penaliza sobre todo las transferencias grandes |
| Uso del disco con 1 VM | `iostat -xm sda 5` durante el apagado de W11 | **%util 80–93 %** moviendo solo 20–40 MB/s | El disco está **saturado**; CPU al 80–90 % libre y RAM sobrada |

Salidas completas: [casa-disco-fio](../anexos/pruebas-hardware/casa-disco-fio-20261122.txt) · [iostat W11](../anexos/rendimiento/e0-w11-apagado-colgado-iostat-20261122.txt).

**Conclusión:** el cuello de botella del equipo de casa no es la CPU ni la RAM, es el **puerto USB 2.0** donde está enchufado el SSD que contiene Linux Mint y todas las VM.

## 3. Solución

| Opción | Esfuerzo | Mejora esperada | Estado |
|---|---|---|---|
| **A. Enchufar el SSD a un puerto USB 3.x** (azul/rojo o marcado SS10/SS20; en la H510M H, los traseros USB 3.2) | Nulo | ×10 en secuencial (de ~40 a ~400+ MB/s) | **Propuesta**: requiere apagar el equipo, porque el sistema arranca desde ese disco |
| B. Mover las VM más usadas al NVMe interno (970 EVO Plus) | Medio | Máxima | Descartada: ese disco es del sistema Windows de casa y el enunciado pide que el entorno viaje en el disco USB |
| C. Reducir la E/S de las VM: servidores sin escritorio, desactivar indexación/actualizaciones de Windows en las pruebas | Bajo | Moderada | ✅ Aplicada: servidores Linux sin escritorio, escenarios con un solo router y caché de E/S del anfitrión (optimizaciones 1 y 2 de la [T7](../tareas/T7-rendimiento.md)) |

## 4. Verificación (cuando se cambie el puerto)

```bash
lsusb -t | grep -i 'Mass Storage'        # debe salir 5000M, 10000M o 20000M
./scripts/pruebas-hardware.sh disco       # repetir fio y comparar con la tabla anterior
```

> Cuando se haga el cambio, añadir aquí la salida y la nueva velocidad.

## 5. Qué aprendí

Antes de culpar a la RAM o a la CPU hay que **medir** cada recurso: aquí `vmstat` mostraba CPU ociosa y `iostat` el disco al 90 %. Y un SSD rápido no sirve de nada si el bus que lo conecta es lento.
