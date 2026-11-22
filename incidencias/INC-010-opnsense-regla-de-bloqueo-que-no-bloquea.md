# INC-010 · OPNsense: la regla de bloqueo de HTTP no bloquea

> **Estado: RESUELTA.** Tipo: cortafuegos (ISO RA1). Máquina: [`r-opnsense`](../maquinas/r-opnsense/README.md) · 22/11/2026

## Síntoma
Después de crear `BLOQUEO-HTTP` (block TCP 80, secuencia 51), `curl http://www.debian.org` desde `srv-linux` seguía respondiendo (**302**) y el registro no mostraba ningún bloqueo.

## Causa
Las reglas se evalúan por **número de secuencia** y gana **la primera que coincide**. La regla de serie *Default allow LAN to any rule* tenía la secuencia **1**: dejaba pasar todo antes de llegar a la mía. Además no registra, por eso el log no mostraba nada.

## Solución
`set_rule` de las dos *Default allow* a las secuencias **100 y 101** y `apply` → HTTP bloqueado y 7 líneas `BLOQUEO-HTTP` en el registro ([02-reglas-y-orden.txt](../maquinas/r-opnsense/salidas/02-reglas-y-orden.txt)).

## Aprendizaje
Es el mismo principio en los tres routers (MikroTik `place-before`, nftables por orden en la cadena, OPNsense por secuencia): **lo específico arriba y lo general abajo**.
