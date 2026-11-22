# INC-008 · Windows no conecta por HTTPS «aunque hay Internet»: revocación bloqueada por la regla de HTTP

> **Estado: DIAGNOSTICADA (comportamiento esperado de la regla).** Tipo: red / cortafuegos (ISO RA1). Máquinas: [`srv-dc`](../maquinas/srv-dc/README.md) detrás de [`r-opnsense`](../maquinas/r-opnsense/README.md) · 22/11/2026

## Síntoma
En la prueba de fallo de OPNsense, el paso «antes» ya dio **sin Internet** desde `srv-dc` (`curl.exe` devolvía 000), mientras que `ping 1.1.1.1` y la resolución DNS funcionaban.

## Diagnóstico
```text
PS> curl.exe -sS https://www.debian.org
curl: (35) schannel: next InitializeSecurityContext failed: CRYPT_E_REVOCATION_OFFLINE (0x80092013)
      - The revocation function was unable to check revocation because the revocation server was offline.
PS> curl.exe --ssl-no-revoke https://www.debian.org   → 200
```
El `curl.exe` de Windows usa **Schannel**, que comprueba si el certificado del servidor está revocado descargando la **CRL / respuesta OCSP**. Esos servidores se publican por **HTTP (puerto 80)**, y la regla `BLOQUEO-HTTP` de la LAN los corta. El `curl` de Linux no hace esa comprobación por defecto y por eso `srv-linux` no lo notaba.

## Solución y aprendizaje
- Para las pruebas: `curl.exe --ssl-no-revoke`.
- En una empresa real, un bloqueo «de todo HTTP» rompe la comprobación de certificados de Windows Update, los navegadores y Office. Lo correcto es **permitir HTTP hacia los servidores de CRL/OCSP** (con un alias de dominios de las autoridades de certificación) o usar un proxy.
- Un bloqueo de red tiene efectos secundarios: hay que probar con varios sistemas operativos.
