# Autoevaluación con la rúbrica individual (ASIX ThinkLab · «Naix un sistema» 2.0)

Generada a partir de la rúbrica oficial (`Rubrica-autoavaluacio-Individual`). Para cada criterio: nivel, RA, estado **real** y enlace a la evidencia. Actualizada el 22/11/2026.

Leyenda: ✅ hecho y con evidencia · 🟡 parcial · ⏳ pendiente (con guía) · 📅 se evalúa en la prueba presencial (preparado)

## Resumen

| Nivel | ✅ | 🟡 | ⏳ | 📅 | Total |
|---|---:|---:|---:|---:|---:|
| Apte | 58 | 1 | 10 | 9 | 78 |
| Apte+ | 9 | 4 | 0 | 5 | 18 |
| **Total** | **67** | **5** | **10** | **14** | **96** |

**Lo que queda pendiente:** clúster Proxmox (7 criterios; no cabe en la RAM del equipo de casa), `cli-win11` (3; hace falta la contraseña de la cuenta), tests de hardware en el equipo de clase y la optimización del puerto USB 3 (cambios físicos).

## T0 · Entorno de pruebas

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a17 | Apte | FDM-RA1 | Preparar l’entorn propi de proves. | ✅ Hecho | [T0](../tareas/T0-entorno-de-pruebas.md): 12 VM creadas, 9 instaladas y configuradas |
| a18 | Apte | FDM-RA1 | Identificar-ne els recursos físics i justificar-ne les limitacions. | ✅ Hecho | [T0 §4](../tareas/T0-entorno-de-pruebas.md) · [T7](../tareas/T7-rendimiento.md) |
| a127 | Apte+ | FDM-RA1 | Documentar l’entorn propi en Markdown i Git: esquema de VM, recursos i problemes resolts. | ✅ Hecho | Este repositorio (Markdown + Git), esquema en la [T0](../tareas/T0-entorno-de-pruebas.md) |

## T2 · Equipos y periféricos

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a19 | Apte | FDM-RA1 | Inventariar l’equip de classe i el de casa. | ✅ Hecho | [T2 §1](../tareas/T2-equipos-clase-y-casa.md) |
| a20 | Apte | FDM-RA1 | Comparar els equips i identificar colls de botella. | ✅ Hecho | [T2 §2 y §4](../tareas/T2-equipos-clase-y-casa.md) |
| a21 | Apte | FDM-RA1 | Proposar solucions ajustades al maquinari disponible. | ✅ Hecho | [T2 §5](../tareas/T2-equipos-clase-y-casa.md) |
| a27 | Apte+ | FDM-RA1 | Executar tests de memòria, disc i xarxa en l’equip de classe i en el de casa. | 🟡 Parcial | Casa ✅ ([T2 §3](../tareas/T2-equipos-clase-y-casa.md)) · clase ⏳ (`scripts/pruebas-hardware.sh`) |
| a28 | Apte+ | FDM-RA1 | Registrar l’eina, les condicions i els resultats dels tests. | 🟡 Parcial | Herramienta, condiciones y resultados registrados para casa ([anexos/pruebas-hardware](../anexos/pruebas-hardware/)) |
| a29 | Apte+ | FDM-RA1 | Confirmar o descartar amb dades els colls de botella previstos. | ✅ Hecho | [T2 §4](../tareas/T2-equipos-clase-y-casa.md): disco confirmado; CPU y red descartadas |

## T4 · Diseño físico y lógico

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a128 | Apte | ISO-RA1 | Dibuixar l’esquema de xarxa individual, el muntatge virtual i les adreces previstes. | ✅ Hecho | [T4 §2–3](../tareas/T4-red-individual.md) |
| a148 | Apte | ISO-RA1 | Indicar la configuració de cada interfície i la LAN 192.168.XX.0/24 segons el lloc a l’aula; la WAN pot obtindre la IP per DHCP (adaptador pont o millor NAT). | ✅ Hecho | [T4 §4](../tareas/T4-red-individual.md): LAN 192.168.29.0/24, WAN por NAT |
| a129 | Apte+ | ISO-RA1 | Implementar la xarxa individual i comprovar la connectivitat amb ping, traceroute i taules d’encaminament. | ✅ Hecho | [T4 §5](../tareas/T4-red-individual.md) con los tres routers |
| a149 | Apte+ | ISO-RA1 | Aportar evidències de ping, traceroute, taula d’encaminament i configuració de les interfícies entre les VM i cap a l’exterior. | ✅ Hecho | [srv-07](../maquinas/srv-linux/capturas/srv-07-red-ping-traceroute-rutas.png), [nft-04](../maquinas/r-nftables/capturas/nft-04-interfaces-rutas-forward.png), [mk-05](../maquinas/r-mikrotik/capturas/mk-05-interfaces-ip.png) |

## T5 · Instalación y comunicaciones

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a78 | Apte | ISO-RA1 | Comprovar els requisits i l’origen de les imatges d’instal·lació (arquitectura, fiabilitat de l'origen, etc). Verificar la integritat de les imatges quan el fabricant publique el mecanisme | ✅ Hecho | [T5 §2](../tareas/T5-sistemas-e-imagenes.md) · [SHA256](../anexos/sha256-imagenes-20261122.txt) |
| a79 | Apte | ISO-RA1 | Abans de ficar en producció, realitzar l'actualització i comprovació del correcte funcionament del sistemes instal·lats. | ✅ Hecho | r-nftables, srv-linux, cli-linux → Debian 13.8; r-opnsense 26.7 → 26.7.9_3 ([T5](../tareas/T5-sistemas-e-imagenes.md)); Proxmox ⏳ |
| a203 | Apte | ISO-RA1 | MikroTik: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) |
| a204 | Apte | ISO-RA1 | MikroTik: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) |
| a205 | Apte | ISO-RA1 | MikroTik: configurar els paràmetres de xarxa de les interfícies WAN i LAN. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) |
| a206 | Apte | ISO-RA1 | MikroTik: permetre l’accés a Internet des dels equips de la LAN. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) |
| a207 | Apte | ISO-RA1, ISO-RA6 | MikroTik: provar una connexió permesa i una bloquejada i interpretar el registre. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) §3 |
| a208 | Apte | ISO-RA3 | MikroTik: guardar la còpia de configuració o sistema al servidor de còpies. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) §4 |
| a209 | Apte | ISO-RA3 | MikroTik: provocar una errada controlada i comprovar la recuperació de l’equip o la part afectada. | ✅ Hecho | [r-mikrotik](../maquinas/r-mikrotik/README.md) §5: 39 s |
| a210 | Apte | ISO-RA1 | OPNsense: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) |
| a211 | Apte | ISO-RA1 | OPNsense: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) |
| a212 | Apte | ISO-RA1 | OPNsense: configurar els paràmetres de xarxa de les interfícies WAN i LAN. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) |
| a213 | Apte | ISO-RA1 | OPNsense: permetre l’accés a Internet des dels equips de la LAN. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) |
| a214 | Apte | ISO-RA1, ISO-RA6 | OPNsense: provar una connexió permesa i una bloquejada i interpretar el registre. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) §3 · orden de reglas |
| a215 | Apte | ISO-RA3 | OPNsense: guardar la còpia de configuració o sistema al servidor de còpies. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) §4: copia cifrada |
| a216 | Apte | ISO-RA3 | OPNsense: provocar una errada controlada i comprovar la recuperació de l’equip o la part afectada. | ✅ Hecho | [r-opnsense](../maquinas/r-opnsense/README.md) §5: 69 s |
| a217 | Apte | ISO-RA1 | GNU/Linux amb nftables: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) |
| a218 | Apte | ISO-RA1 | GNU/Linux amb nftables: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) |
| a219 | Apte | ISO-RA1 | GNU/Linux amb nftables: configurar els paràmetres de xarxa de les interfícies WAN i LAN. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) |
| a220 | Apte | ISO-RA1 | GNU/Linux amb nftables: permetre l’accés a Internet des dels equips de la LAN. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) |
| a221 | Apte | ISO-RA1, ISO-RA6 | GNU/Linux amb nftables: provar una connexió permesa i una bloquejada i interpretar el registre. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) §2 |
| a222 | Apte | ISO-RA3 | GNU/Linux amb nftables: guardar la còpia de configuració o sistema al servidor de còpies. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) §3 |
| a223 | Apte | ISO-RA3 | GNU/Linux amb nftables: provocar una errada controlada i comprovar la recuperació de l’equip o la part afectada. | ✅ Hecho | [r-nftables](../maquinas/r-nftables/README.md) §4: 1,3 s |
| a224 | Apte | ISO-RA1 | TrueNAS: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [nas-truenas](../maquinas/nas-truenas/README.md) |
| a225 | Apte | ISO-RA1 | TrueNAS: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [nas-truenas](../maquinas/nas-truenas/README.md) |
| a226 | Apte | ISO-RA1 | TrueNAS: configurar els paràmetres de xarxa de les interfícies. | ✅ Hecho | [nas-truenas](../maquinas/nas-truenas/README.md) |
| a227 | Apte | ISO-RA3 | TrueNAS: preparar un disc addicional o, si no és possible, una partició addicional per a les còpies dels equips crítics. | ✅ Hecho | [nas-truenas](../maquinas/nas-truenas/README.md) |
| a228 | Apte | ISO-RA1 | Proxmox: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a229 | Apte | ISO-RA1 | Proxmox: configurar l’usuari o usuaris d’administració. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a230 | Apte | ISO-RA1 | Proxmox: configurar els paràmetres de xarxa de les interfícies. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a231 | Apte | ISO-RA3 | Proxmox: copiar les configuracions o imatges necessàries al servidor corresponent i justificar què es copia i què no. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a232 | Apte | ISO-RA1 | Proxmox: configurar el clúster amb els nodes disponibles; si no hi ha nodes suficients, registrar el disseny o la simulació autoritzada. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a235 | Apte | ISO-RA1, ISO-RA6 | Proxmox: executar la migració d’un contenidor i una VM entre nodes disponibles. La migració de una VM haurà de ser d'un sistema ubuntu server o debian sense entorn gràfic per a que siga més ràpid. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a236 | Apte | ISO-RA6 | Proxmox individual: mesurar temps i espai de la migració de VM i contenidor, interpretar-los i valorar millores. | ⏳ Pendiente | [pve1-3](../maquinas/pve1/README.md): VM con VT-x anidada e ISO verificada; instalación y clúster pendientes |
| a237 | Apte | ISO-RA1 | Windows Server 2025: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [srv-dc](../maquinas/srv-dc/README.md) |
| a238 | Apte | ISO-RA1 | Windows Server 2025: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [srv-dc](../maquinas/srv-dc/README.md) |
| a239 | Apte | ISO-RA1 | Windows Server 2025: configurar els paràmetres de xarxa de les interfícies. | ✅ Hecho | [srv-dc](../maquinas/srv-dc/README.md) |
| a240 | Apte | ISO-RA3 | Windows Server 2025: copiar les configuracions o imatges necessàries al servidor corresponent i justificar què es copia i què no. | ✅ Hecho | [srv-dc](../maquinas/srv-dc/README.md) §4: copia diaria de AD |
| a241 | Apte | ISO-RA1 | Windows Server 2025: explicar què és un domini i què aporta la gestió centralitzada a l’empresa. | ✅ Hecho | [srv-dc](../maquinas/srv-dc/README.md) §3 |
| a242 | Apte | ISO-RA1 | Servidors GNU/Linux d’infraestructura: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [srv-linux](../maquinas/srv-linux/README.md) |
| a243 | Apte | ISO-RA1 | Servidors GNU/Linux d’infraestructura: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [srv-linux](../maquinas/srv-linux/README.md) |
| a244 | Apte | ISO-RA1 | Servidors GNU/Linux d’infraestructura: configurar els paràmetres de xarxa de les interfícies. | ✅ Hecho | [srv-linux](../maquinas/srv-linux/README.md) |
| a245 | Apte | ISO-RA3 | Servidors GNU/Linux d’infraestructura: copiar les configuracions o imatges necessàries al servidor corresponent i justificar què es copia i què no. | ✅ Hecho | [srv-linux](../maquinas/srv-linux/README.md) §4 |
| a246 | Apte | ISO-RA1 | En cada servidor GNU/Linux d’infraestructura: instal·lar i configurar el programari necessari per a la seua funcionalitat. De moment cap programari addicional, es veurà en tasques posteriors. | ✅ Hecho | [srv-linux](../maquinas/srv-linux/README.md) |
| a247 | Apte | ISO-RA1 | Windows 11: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | 🟡 Parcial | [cli-win11](../maquinas/cli-win11/README.md) : instalado y arranca; sin la contraseña no se puede entrar |
| a248 | Apte | ISO-RA1 | Windows 11: configurar l’usuari o usuaris d’administració. | ⏳ Pendiente | [cli-win11](../maquinas/cli-win11/README.md) : necesita iniciar sesión |
| a249 | Apte | ISO-RA1 | Windows 11: configurar els paràmetres de xarxa de les interfícies. | ⏳ Pendiente | [cli-win11](../maquinas/cli-win11/README.md) |
| a250 | Apte | ISO-RA3 | Windows 11: copiar les configuracions o imatges necessàries al servidor corresponent i justificar què es copia i què no. | ⏳ Pendiente | [cli-win11](../maquinas/cli-win11/README.md) |
| a252 | Apte | ISO-RA1 | GNU/Linux client: instal·lar el sistema previst i comprovar-ne la versió i el funcionament. | ✅ Hecho | [cli-linux](../maquinas/cli-linux/README.md) |
| a253 | Apte | ISO-RA1 | GNU/Linux client: configurar l’usuari o usuaris d’administració. | ✅ Hecho | [cli-linux](../maquinas/cli-linux/README.md) : `adminlab` |
| a254 | Apte | ISO-RA1 | GNU/Linux client: configurar els paràmetres de xarxa de les interfícies. | ✅ Hecho | [cli-linux](../maquinas/cli-linux/README.md) |
| a255 | Apte | ISO-RA3 | GNU/Linux client: copiar les configuracions o imatges necessàries al servidor corresponent i justificar què es copia i què no. | ✅ Hecho | [cli-linux](../maquinas/cli-linux/README.md) |
| a258 | Apte | ISO-RA1 | Identificar possibles problemes dels diferents sistemes, detectar configuracions crítiques, temps de resposta davant una incidència d’instal·lació o arrencada. | ✅ Hecho | [T5 §4](../tareas/T5-sistemas-e-imagenes.md) |
| a259 | Apte | ISO-RA1 | Preparar l’espai de còpies de seguretat en TrueNAS. Justificar què és còpia, com i on. | ✅ Hecho | [Plan de copias](../tareas/T5-plan-de-copias.md) · [nas-truenas](../maquinas/nas-truenas/README.md) |
| a105 | Apte+ | ISO-RA3 | Automatitzar les còpies de configuracions o imatges. | ✅ Hecho | MikroTik (scheduler), Debian (systemd), Windows (tarea programada) · [plan de copias](../tareas/T5-plan-de-copias.md) |

## T6 · Almacenamiento y recuperación

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a102 | Apte | ISO-RA3 | Crear i verificar almenys tres tipus de RAID. | ✅ Hecho | RAID 0, 1 y 5 con fallo y reconstrucción · [T6](../tareas/T6-almacenamiento-y-recuperacion.md) |
| a103 | Apte | ISO-RA3 | Explicar què aporta cada tipus de RAID. | ✅ Hecho | [T6 §1](../tareas/T6-almacenamiento-y-recuperacion.md) |
| a107 | Apte+ | ISO-RA3 | Investigar i justificar l’espill entre discos de dos equips diferents. | ✅ Hecho | [T6 §4](../tareas/T6-almacenamiento-y-recuperacion.md): DRBD frente a GlusterFS, Ceph y ZFS |
| a108 | Apte+ | ISO-RA3 | Implementar l’espill entre dos discos de dos equips mitjançant la solució de replicació o emmagatzematge distribuït seleccionada. | ✅ Hecho | DRBD `srv-linux` ↔ `srv-linux2` · [srv-linux2](../maquinas/srv-linux2/README.md) |
| a109 | Apte+ | ISO-RA3 | Verificar el funcionament i explicar un cas d’ús. | ✅ Hecho | Caída del primario, relevo en 3,5 s, cero pérdida; caso de uso · [srv-linux2](../maquinas/srv-linux2/README.md) |

## T7 · Rendimiento y diagnóstico

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a22 | Apte | FDM-RA1 | Mesurar CPU, RAM, disc i xarxa durant les càrregues previstes. | ✅ Hecho | [T7 §2](../tareas/T7-rendimiento.md) |
| a23 | Apte | FDM-RA1, ISO-RA6 | Interpretar les mesures i identificar els recursos saturats. | ✅ Hecho | [T7 §3](../tareas/T7-rendimiento.md) |
| a24 | Apte | FDM-RA1 | Determinar la capacitat del maquinari per executar les VM. | ✅ Hecho | [T7 §4](../tareas/T7-rendimiento.md) |
| a119 | Apte | ISO-RA6 | Analitzar els recursos físics amb diferents càrregues de VM. | ✅ Hecho | 5 escenarios medidos · [T7](../tareas/T7-rendimiento.md) |
| a120 | Apte | ISO-RA6 | Determinar quantes VM permeten treballar sense bloquejar l’equip. | ✅ Hecho | [T7 §4](../tareas/T7-rendimiento.md) |
| a121 | Apte | ISO-RA6 | Lliurar l’informe de mesures i conclusions. | ✅ Hecho | [T7](../tareas/T7-rendimiento.md) |
| a123 | Apte+ | ISO-RA6 | Proposar i aplicar una primera optimització de les VM. | ✅ Hecho | Servidores sin escritorio (medida) · [T7 §5](../tareas/T7-rendimiento.md) |
| a124 | Apte+ | ISO-RA6 | Proposar i aplicar una segona optimització de les VM. | 🟡 Parcial | Caché de E/S del anfitrión aplicada en srv-dc, sin medir · USB 3 pendiente · [T7 §5](../tareas/T7-rendimiento.md) |
| a125 | Apte+ | ISO-RA6 | Comparar les mesures de rendiment abans i després. | 🟡 Parcial | Antes/después medido para la optimización 1; falta la 2 |

## T8 · Prueba final

| ID | Nivel | RA | Criterio | Estado | Evidencia |
|---|---|---|---|---|---|
| a25 | Apte | FDM-RA1 | Diagnosticar i resoldre la incidència de maquinari del cas final. | 📅 El día de la prueba | Ensayado: [INC-002](../incidencias/INC-002-ssd-portatil-en-usb2.md) |
| a26 | Apte | FDM-RA1, ISO-RA1, ISO-RA3, ISO-RA6 | Justificar la solució i comprovar el resultat. | 📅 El día de la prueba | Método en la [T8 §1](../tareas/T8-prueba-final.md) |
| a50 | Apte | FDM-RA4 | Identificar els equips empresarials i la seua funció en el cas final. | 📅 El día de la prueba | Preparación en la [T8 §3](../tareas/T8-prueba-final.md) |
| a51 | Apte | FDM-RA4 | Inventariar les connexions i els ports del cas assignat. | 📅 El día de la prueba | Preparación en la [T8 §3](../tareas/T8-prueba-final.md) |
| a52 | Apte | FDM-RA4 | Analitzar alimentació, ventilació i ordre del cablejat. | 📅 El día de la prueba | Preparación en la [T8 §3](../tareas/T8-prueba-final.md) |
| a53 | Apte | FDM-RA4 | Aportar l’esquema i l’explicació individual de la solució. | 📅 El día de la prueba | Preparación en la [T8 §3](../tareas/T8-prueba-final.md) |
| a80 | Apte | ISO-RA1 | Resoldre la incidència d’instal·lació, actualització o arrencada del cas final. | 📅 El día de la prueba | Ensayado: [INC-001](../incidencias/INC-001-cli-linux-pantalla-negra-sin-grub.md), [INC-004](../incidencias/INC-004-instalacion-desatendida-postinstall-fallido.md) |
| a104 | Apte | ISO-RA3 | Recuperar la informació o el sistema previst en el cas final. | 📅 El día de la prueba | Ensayado: restauraciones de los 3 routers, RAID y DRBD |
| a122 | Apte | ISO-RA6 | Diagnosticar el problema de rendiment del cas final. | 📅 El día de la prueba | Chuleta en la [T7 §6](../tareas/T7-rendimiento.md) |
| a30 | Apte+ | FDM-RA1 | Respondre el bloc del qüestionari teòric/pràctic corresponent a FDM RA1, justificant les respostes. El bloc ha d’estar identificat per RA; complementa les evidències pràctiques. | 📅 El día de la prueba | Repaso en [defensa/preguntas](../defensa/preguntas.md) |
| a57 | Apte+ | FDM-RA4 | Respondre el bloc del qüestionari teòric/pràctic corresponent a FDM RA4, justificant les respostes. El bloc ha d’estar identificat per RA; complementa les evidències pràctiques. | 📅 El día de la prueba | Repaso en [defensa/preguntas](../defensa/preguntas.md) |
| a84 | Apte+ | ISO-RA1 | Respondre el bloc del qüestionari teòric/pràctic corresponent a ISO RA1, justificant les respostes. El bloc ha d’estar identificat per RA; complementa les evidències pràctiques. | 📅 El día de la prueba | Repaso en [defensa/preguntas](../defensa/preguntas.md) |
| a110 | Apte+ | ISO-RA3 | Respondre el bloc del qüestionari teòric/pràctic corresponent a ISO RA3, justificant les respostes. El bloc ha d’estar identificat per RA; complementa les evidències pràctiques. | 📅 El día de la prueba | Repaso en [defensa/preguntas](../defensa/preguntas.md) |
| a126 | Apte+ | ISO-RA6 | Respondre el bloc del qüestionari teòric/pràctic corresponent a ISO RA6, justificant les respostes. El bloc ha d’estar identificat per RA; complementa les evidències pràctiques. | 📅 El día de la prueba | Repaso en [defensa/preguntas](../defensa/preguntas.md) |

