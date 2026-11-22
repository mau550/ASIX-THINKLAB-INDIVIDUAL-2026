# INC-003 · `cli-win11` se queda colgada al apagarse

> **Estado: RESUELTA (recuperación comprobada); causa de fondo en [INC-002](INC-002-ssd-portatil-en-usb2.md).** Tipo: arranque/apagado y rendimiento (ISO RA1, ISO RA6).
> Máquina: [`cli-win11`](../maquinas/cli-win11/README.md) · Fecha: 22/11/2026

## 1. Síntoma

1. Se pulsó el botón de apagado ACPI (`VBoxManage controlvm W11 acpipowerbutton`) con Windows en la pantalla de bloqueo.
2. La pantalla pasó a negro y la VM siguió encendida **más de 25 minutos**, con el proceso `VBoxHeadless` al **200 % de CPU** (las 2 vCPU al máximo) durante los primeros minutos.

![Pantalla negra durante el apagado](../maquinas/cli-win11/capturas/w11-03-apagado-colgado-pantalla-negra.png)

## 2. Diagnóstico

| Prueba | Resultado |
|---|---|
| `top` en el anfitrión | `VBoxHeadless` 200 % CPU, 4,2 GB RES, `wa` 6 % |
| `iostat -xm sda 5` | Disco al **80–93 %** de uso con solo 20–40 MB/s → saturado ([salida](../anexos/rendimiento/e0-w11-apagado-colgado-iostat-20261122.txt)) |
| `vmstat 5` | CPU del anfitrión 80–90 % libre, sin *swap* ([salida](../anexos/rendimiento/e0-w11-apagado-colgado-vmstat-20261122.txt)) |
| `VBox.log` de la VM | `AHCI#0: Port 0 reset` y `VD#0: Cancelling all active requests` a los 11 min |

**Interpretación:** al apagarse, Windows escribió mucho en el disco (probablemente actualizaciones pendientes: la VM llevaba sin encenderse desde el 13/10). El SSD del laboratorio está en un puerto USB 2.0 ([INC-002](INC-002-ssd-portatil-en-usb2.md)) y no daba abasto. El controlador AHCI virtual agotó el tiempo de espera, reinició el puerto y canceló las peticiones pendientes. A partir de ahí Windows se quedó esperando un disco que ya no le respondía.

## 3. Solución

1. Esperar a que el disco quedara inactivo (`iostat` sin actividad de la VM) para no cortar una escritura a medias.
2. Reintentar el apagado ACPI → sin respuesta en 60 s.
3. **Apagado forzado**: `VBoxManage controlvm W11 poweroff`.

## 4. Verificación

Se volvió a arrancar la VM (escenario E2a de la [T7](../tareas/T7-rendimiento.md)) y Windows llegó a la pantalla de bloqueo **en menos de 2 minutos**, sin pedir reparación de disco:

![Arranque correcto tras el apagado forzado](../maquinas/cli-win11/capturas/w11-02-arranque-tras-apagado-forzado.png)

## 5. Prevención

- Arreglar la causa: el SSD en un puerto USB 3.x ([INC-002](INC-002-ssd-portatil-en-usb2.md)).
- Apagar Windows **desde dentro** (`shutdown /s /t 0`) con la sesión iniciada. En la pantalla de bloqueo, el botón ACPI no siempre se atiende.
- Antes de cambios grandes, tomar una **instantánea** de la VM (`VBoxManage snapshot cli-win11 take antes-de-X`).

## 6. Se repitió en `srv-dc` (22/11, durante la instalación y la promoción a DC)

Con la actualización de OPNsense y la instalación de Windows Server escribiendo a la vez en el SSD USB 2.0, el registro de `srv-dc` volvió a mostrar `AHCI#0: Port 0 reset` dos veces: Windows quedó en pantalla negra. Se recuperó con un reinicio en frío. Hubo un reinicio AHCI más durante la configuración del dominio, del que Windows sí se recuperó solo. **Mitigación aplicada al final** (con la VM apagada): caché de E/S del anfitrión en el controlador SATA (`VBoxManage storagectl srv-dc --name SATA --hostiocache on`), para que las escrituras se acumulen en la RAM del anfitrión en lugar de esperar al disco. Medido después: **0 reinicios AHCI** en el arranque y en dos copias de AD ([evidencia](../anexos/rendimiento/opt2-cache-io-srv-dc-20261122.txt)). La solución de fondo sigue siendo [INC-002](INC-002-ssd-portatil-en-usb2.md).
