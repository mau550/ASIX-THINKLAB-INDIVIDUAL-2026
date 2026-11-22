# INC-009 · La copia de AD funciona a mano pero falla en la tarea programada (SYSTEM)

> **Estado: RESUELTA.** Tipo: copias de seguridad (ISO RA3). Máquina: [`srv-dc`](../maquinas/srv-dc/README.md) · 22/11/2026

## Síntoma
La tarea programada «Copia AD al NAS» terminaba con `LastTaskResult 1`. El `.zip` se creaba, pero no llegaba al NAS. Lanzado a mano como `Administrator`, `scp` funcionaba (`Authenticated … using "publickey"`, `Exit status 0`).

## Diagnóstico
| Hipótesis | Prueba | Resultado |
|---|---|---|
| Permisos del dataset en el NAS | La subida manual funcionó | Descartada |
| ACL de la clave con una cuenta de más (`ISO29\Administrator:(M)`) | Quitada esa entrada → sigue fallando | Insuficiente |
| Qué ve SYSTEM | Tarea puntual como SYSTEM con `scp -v` | `WARNING: UNPROTECTED PRIVATE KEY FILE! … bad permissions` |

Causa: el **propietario** del fichero `copia_nas` era `ISO29\Administrator`, que fue quien lo creó. OpenSSH para Windows exige que la clave privada pertenezca a la cuenta que la usa (o a SYSTEM/Administradores) y que nadie más pueda leerla.

## Solución
```powershell
icacls C:\ProgramData\copias\copia_nas /inheritance:r /grant:r "SYSTEM:F" "BUILTIN\Administrators:F"
icacls C:\ProgramData\copias\copia_nas /setowner "SYSTEM"
```
## Verificación
`LastTaskResult 0` · `OK: srv-dc-ad-20261122-2033.zip (4.7 MB) subida a c-srvdc@nas-truenas` · el fichero aparece en `/mnt/copias/srv-dc` con uid 3004 ([evidencia](../maquinas/srv-dc/salidas/05-copia-automatica-ad-al-nas.txt)).
