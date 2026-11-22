# `srv-dc` · Windows Server 2025 · Controlador de dominio

> **Estado: ⏳ VM creada (UEFI + TPM 2.0). Falta descargar la ISO de evaluación e instalar.**

| Dato | Valor |
|---|---|
| Función | Gestión centralizada: Active Directory + DNS del dominio `iso29.lan` |
| Sistema | Windows Server 2025 Standard **Evaluation** (180 días) con experiencia de escritorio |
| Imagen | Descargar de <https://www.microsoft.com/evalcenter/download-windows-server-2025>. Microsoft **no publica** el SHA256 de esta ISO: se anota el calculado para comprobar más adelante que no ha cambiado |
| Recursos | 2 vCPU · 4 GB · 50 GB · **UEFI + TPM 2.0** |
| Red | `lan-iso`, **IP fija 192.168.29.13/24**, pasarela 192.168.29.1, **DNS = 127.0.0.1** (él mismo, cuando sea DC) |
| Configuración VirtualBox | [config/virtualbox-showvminfo.txt](config/virtualbox-showvminfo.txt) |

## ¿Qué es un dominio y qué aporta? (a241)

Un **dominio** de Active Directory es una base de datos central de **usuarios, equipos y políticas** (GPO), gestionada por uno o varios **controladores de dominio**.

| Sin dominio (grupo de trabajo) | Con dominio |
|---|---|
| Cada equipo tiene sus propios usuarios: si alguien cambia de puesto, hay que crearle la cuenta otra vez | **Una cuenta por persona** válida en todos los equipos (inicio de sesión único) |
| Las configuraciones se hacen equipo por equipo | Las **GPO** aplican normas (contraseñas, bloqueos, unidades de red, software) a cientos de equipos a la vez |
| Dar de baja a alguien significa ir a cada equipo | Se desactiva **una** cuenta y pierde el acceso a todo |
| Sin auditoría central | Registro central de inicios de sesión |

Para la empresa del proyecto (5 departamentos) supone menos trabajo de administración, más seguridad y altas y bajas inmediatas.

## Criterios pendientes: a237–a240

## Guía

1. Montar la ISO: `VBoxManage storageattach srv-dc --storagectl SATA --port 1 --type dvddrive --medium <iso>` y arrancar.
2. Instalar *Standard (Desktop Experience)*. 📸 `winver` y el disco en *Administración de discos* (particiones EFI, MSR, Windows y recuperación).
3. Zona horaria (`tzutil /s "Romance Standard Time"`), nombre `srv-dc`, IP fija (`New-NetIPAddress`). 📸 `ipconfig /all`.
4. `Install-WindowsFeature AD-Domain-Services -IncludeManagementTools` → `Install-ADDSForest -DomainName iso29.lan`. 📸 *Usuarios y equipos de AD*.
5. **Usuario (a238):** `mauro` en *Domain Admins*; el `Administrator` integrado solo para emergencias.
6. **Copia (a240):** `wbadmin start systemstatebackup` o exportar AD con `ntdsutil "ac i ntds" "ifm" "create sysvol full C:\ifm"` → comprimir → `scp` a `c-srvdc@192.168.29.10:/mnt/copias/srv-dc/`. **No** se copia la imagen entera de 50 GB: se reinstala el servidor y se restaura el estado del sistema.
