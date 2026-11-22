# Preguntas para la defensa y el cuestionario (por RA)

Respuestas cortas, cada una apoyada en algo que **he hecho y medido** en este laboratorio.

## FDM RA1 · Hardware y rendimiento del equipo

1. **¿Cuál es el cuello de botella de tu equipo de casa y cómo lo demostraste?**
   El SSD del laboratorio está en un puerto USB 2.0. `lsusb -t` muestra `480M` y `fio` da 41 MB/s. Con una sola VM de Windows, `iostat` marca el disco al 80–93 % mientras la CPU está al 85 % libre.
2. **¿Cómo confirmas o descartas un cuello de botella?** Midiendo cada recurso bajo carga: CPU (`vmstat id`), RAM (`si/so`, `free`), disco (`iostat %util`, `await`) y red (`ping`, `curl`). Se descarta lo que tiene margen.
3. **¿Por qué no caben todas las VM a la vez?** Suman 34 GB de RAM asignada; en casa hay 16 GB. Al añadir 5 GB sobre dos VM de escritorio, el sistema empezó a hacer *swap* (8 MB/s).
4. **¿Qué mejora propones con el hardware que tienes?** Conectar el SSD a un puerto USB 3.x (coste cero) y trabajar por escenarios. Con dinero, ampliar a 32 GB de RAM.

## FDM RA4 · Equipos empresariales

5. **Diferencia entre un servidor de rack y un PC.** Fuentes redundantes, gestión fuera de banda (iDRAC/iLO), memoria ECC, discos intercambiables en caliente, flujo de aire de pasillo frío a pasillo caliente.
6. **¿Para qué sirve un SAI?** Mantiene la corriente durante un corte y avisa a los servidores para que se apaguen con orden.
7. **¿Por qué etiquetar el cableado?** Para identificar cada enlace sin seguir el cable: menos tiempo de diagnóstico y menos errores.

## ISO RA1 · Instalación y configuración

8. **¿Por qué verificas el SHA256 de una ISO?** Demuestra que la descarga está completa y no se ha modificado. Si el fabricante no publica la suma (Microsoft), se descarga solo de su web por HTTPS y se anota la suma calculada.
9. **¿Qué pasó con la Debian que arrancaba en negro?** El instalador no escribió GRUB en el MBR (`Installing grub on ''`). Se arregló desde el modo rescate con `grub-install /dev/sda`.
10. **BIOS frente a UEFI.** Con BIOS, el cargador va en el MBR y el hueco hasta el sector 2048. Con UEFI, en una partición FAT32 (ESP). Windows 11 y Server 2025 piden UEFI + TPM 2.0.
11. **¿Por qué un servidor lleva IP fija y un cliente DHCP?** Al servidor lo buscan los demás; al cliente no lo busca nadie.
12. **¿Qué hace un router en tu laboratorio?** Reenvía entre la WAN (NAT de VirtualBox) y la LAN, hace NAT, da DHCP y DNS y filtra con reglas.
13. **¿Por qué tu regla de bloqueo en OPNsense no funcionaba?** Estaba detrás de *Default allow LAN* (secuencia 1). Gana la primera regla que coincide.
14. **¿Qué es un dominio?** Una base central de usuarios, equipos y políticas. Una cuenta por persona y GPO para todos los equipos. Yo creé `iso29.lan` con una OU y un grupo por departamento.
15. **¿Por qué falla Windows por HTTPS si bloqueas HTTP?** Comprueba la revocación de certificados (CRL/OCSP) por el puerto 80.
16. **¿Por qué un clúster con 3 nodos y no 2?** Por el quórum: con 2, si cae uno, el que queda no tiene mayoría y se bloquea.

## ISO RA3 · Almacenamiento y recuperación

17. **RAID 0, 1 y 5.** 0: rápido, sin tolerancia. 1: espejo, el 50 % de capacidad. 5: paridad, (n−1) discos útiles, aguanta 1 fallo. Lo probé quitando un disco: el 0 se perdió y el 1 y el 5 siguieron.
18. **¿Un RAID es una copia de seguridad?** No: no protege de borrados, *ransomware* ni incendios. Por eso además copio al NAS.
19. **¿Qué copias y qué no?** Configuración y datos sí; el sistema operativo no (se reinstala desde una ISO verificada).
20. **¿Por qué un usuario por máquina en el NAS?** Privilegio mínimo: un equipo comprometido solo afecta a sus copias.
21. **Espejo entre dos equipos.** DRBD: RAID 1 por red. Apagué el primario y el secundario tenía los datos en 3,5 s.
22. **Regla 3-2-1.** 3 copias, 2 soportes, 1 fuera. Mi laboratorio aún no tiene la copia externa.

## ISO RA6 · Rendimiento

23. **¿Cómo sabes si falta RAM?** `vmstat`: `si/so` distintos de 0 de forma sostenida y poca RAM disponible.
24. **¿Qué optimizaciones aplicaste?** 1) Servidores sin escritorio: 211 MB frente a 1,3 GB. 2) Caché de E/S del anfitrión en `srv-dc` para que Windows no se cuelgue con el disco lento (medida: de 3 y 1 reinicios AHCI por sesión a 0). La mejora de fondo es el puerto USB 3.
25. **¿Cuántas VM caben?** En casa, 2 de escritorio o router + NAS + 1–2 servidores. En clase (30 GiB), el escenario del clúster.
