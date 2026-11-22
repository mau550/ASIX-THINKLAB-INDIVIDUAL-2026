# INC-006 · La copia del MikroTik al NAS falla con `<sftp status: 4>`

> **Estado: RESUELTA.** Tipo: **copias de seguridad** (ISO RA3). Máquinas: [`r-mikrotik`](../maquinas/r-mikrotik/README.md) → [`nas-truenas`](../maquinas/nas-truenas/README.md) · 22/11/2026

## 1. Síntoma

El script `copia-al-nas` generaba bien el backup y el export, pero la subida fallaba después de transferir el fichero:

```text
status: failed  uploaded: 24KiB  total: 24KiB
failure: closing connection: <sftp status: 4> 192.168.29.10:22 (16) (6) (/tool/fetch; line 7)
fetch,info Upload to 192.168.29.10 FAILED
```

## 2. Diagnóstico

| Hipótesis | Comprobación | Resultado |
|---|---|---|
| Usuario o contraseña incorrectos | El error llega después de subir los 24 KiB: la autenticación fue bien | Descartada |
| Permisos de la carpeta | `filesystem.stat /mnt/copias/r-mikrotik` → dueño uid 3000 (`c-mikrotik`), modo `700` | Descartada |
| Ruta de destino | Subida manual con `dst-path=/mnt/copias/r-mikrotik/prueba.rsc` (**absoluta**) → `status: finished` | **Confirmada** |

`SSH_FX_FAILURE` (status 4) es el error genérico de SFTP. `/tool fetch` de RouterOS **no parte del directorio personal** del usuario remoto: con una ruta relativa intentaba crear el fichero en `/`, donde `c-mikrotik` no puede escribir.

## 3. Solución

En [`copia-al-nas.rsc`](../maquinas/r-mikrotik/config/copia-al-nas.rsc):

```text
dst-path=($f . ".backup")                              ✗
dst-path=("/mnt/copias/r-mikrotik/" . $f . ".backup")  ✓
```

## 4. Verificación

```text
script,info copia-al-nas: r-mikrotik-20261122 subida a nas-truenas
/mnt/copias/r-mikrotik: r-mikrotik-20261122.backup (24728 B), r-mikrotik-20261122.rsc (2559 B)
```

[06-copia-al-nas.txt](../maquinas/r-mikrotik/salidas/06-copia-al-nas.txt). En la carpeta queda también `prueba.rsc`, el fichero de la prueba de diagnóstico.
