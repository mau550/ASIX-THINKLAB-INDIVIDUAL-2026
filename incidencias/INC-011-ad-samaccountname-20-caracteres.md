# INC-011 · No se pueden crear dos usuarios del dominio: «not a properly formed account name»

> **Estado: RESUELTA.** Tipo: configuración del dominio (ISO RA1). Máquina: [`srv-dc`](../maquinas/srv-dc/README.md) · 22/11/2026

## Síntoma
De los cinco usuarios de ejemplo, `empleado2.administracion` y `empleado5.informatica` fallaron con:
`New-ADUser : The name provided is not a properly formed account name`.

## Causa
El atributo **`sAMAccountName`** (el nombre «DOMINIO\usuario», compatible con sistemas anteriores a Windows 2000) admite como **máximo 20 caracteres**. Esos dos tenían 24 y 21.

## Solución
Crearlos como `empleado2.admon` y `empleado5.inform` ([evidencia](../maquinas/srv-dc/salidas/03-ou-usuarios-grupos-gpo.txt)). En una empresa se fija una **convención de nombres** corta, por ejemplo inicial + apellido (`agarcia`), y el correo largo va en el UPN.
