
# 02 · Inventario y diagnóstico del entorno individual

Inventario del equipo físico utilizado para el laboratorio individual, incluyendo sus componentes, sistema anfitrión, almacenamiento y máquinas virtuales. Las comprobaciones de rendimiento y los diagnósticos se incorporarán a medida que se realicen las pruebas.

## 1. Identificación del equipo y entorno de trabajo

| Elemento | Características | Observaciones |
|---|---|---|
| Equipo | Ordenador individual | |
| Fabricante y modelo | | Pendiente de identificar |
| Sistema operativo | Linux Mint 22.3 | Sistema anfitrión |
| Plataforma de virtualización | Oracle VirtualBox 7.0.20 | |
| Arquitectura | 64 bits | |
| Uso del equipo | Laboratorio individual ASIX | |
| Ubicación del sistema | SSD externo | Se utiliza tanto para el sistema anfitrión como para el laboratorio |

## 2. Inventario de hardware

### 2.1. Procesador y virtualización

| Característica | Información | Observaciones |
|---|---|---|
| Fabricante | Intel | |
| Modelo | Core Ultra 5 125H | |
| Arquitectura | | Pendiente de completar |
| Núcleos físicos | 14 | |
| Hilos lógicos | 18 | |
| Frecuencia base | | Pendiente de comprobar |
| Frecuencia máxima | | Pendiente de comprobar |
| Memoria caché | | Pendiente de comprobar |
| Virtualización por hardware | Intel VT-x | Disponible |
| Estado de VT-x | | Pendiente de comprobar en firmware |
| Virtualización anidada | | Pendiente de verificar en VirtualBox |
### 2.2. Memoria RAM

| Característica | Información | Observaciones |
|---|---|---|
| Memoria RAM disponible | 30 GiB | Dato del inventario realizado |
| Memoria física instalada | | Pendiente de comprobar |
| Tipo de memoria | | Pendiente de comprobar |
| Frecuencia | | Pendiente de comprobar |
| Número de módulos | | Pendiente de comprobar |
| Distribución de módulos | | Pendiente de comprobar |
| Ranuras ocupadas | | Pendiente de comprobar |
| Ranuras disponibles | | Pendiente de comprobar |
| Memoria máxima admitida | | Pendiente de consultar |
| Memoria de intercambio (swap) | 15 GiB | Dato del inventario anterior |
| ZRAM | | Pendiente de comprobar |

**Valoración:** los 30 GiB disponibles permiten trabajar con varias máquinas virtuales, aunque será necesario distribuir la memoria según cada escenario y evitar ejecutar todos los sistemas simultáneamente.

### 2.3. Almacenamiento

| Unidad | Modelo / tipo | Capacidad | Uso | Estado |
|---|---|---|---|---|
| Disco principal | SSD externo portátil | 931,5 GB | Sistema Linux Mint y laboratorio de virtualización | En uso |
| Disco interno | Samsung NVMe | 953,9 GB | No utilizado en el proyecto | No modificar |

**Distribución de las particiones del SSD externo:**

| Partición | Punto de montaje | Capacidad | Espacio utilizado | Espacio disponible |
|---|---|---:|---:|---:|
| `/dev/sda2` | `/` | 121 GB | 23 GB | 92 GB |
| `/dev/sda3` | `/home` | 795 GB | 60 GB | 695 GB |

**Observaciones:**

El sistema operativo Linux Mint 22.3 y el entorno de trabajo del proyecto se encuentran instalados en el SSD externo. El NVMe Samsung interno queda excluido de las operaciones del laboratorio para evitar modificar el almacenamiento que no forma parte del entorno de pruebas.

### 2.4. Gráficos y otros componentes

| Componente | Modelo o características | Observaciones |
|---|---|---|
| Tarjeta gráfica | | |
| Gráfica integrada | | |
| Controlador gráfico | | |
| Placa base | | |
| Chipset | | |
| Refrigeración | | |
| Temperatura del procesador en reposo | | |
| Temperatura del procesador bajo carga | | |

### 2.5. Interfaces de red y conectividad

| Interfaz | Fabricante / modelo | Velocidad | Dirección IP | Estado |
|---|---|---|---|---|
| Ethernet | | | | |
| Wi-Fi | | | | |
| Bluetooth | | | | |
| Otras interfaces | | | | |

| Comprobación | Resultado | Observaciones |
|---|---|---|
| Conectividad local | | |
| Acceso a Internet | | |
| Velocidad de descarga | | |
| Velocidad de subida | | |
| Latencia | | |
| Pérdida de paquetes | | |

### 2.6. Periféricos y conexiones físicas

| Elemento | Modelo / características | Estado |
|---|---|---|
| Teclado | | |
| Ratón | | |
| Monitor | | |
| Webcam | | |
| Micrófono | | |
| Altavoces / auriculares | | |
| Puertos USB | | |
| Conexiones de vídeo | | |
| Otros periféricos | | |

### 2.7. Firmware y arranque

| Característica | Información | Observaciones |
|---|---|---|
| Tipo de firmware | | UEFI / BIOS |
| Fabricante del firmware | | |
| Versión | | |
| Fecha | | |
| Secure Boot | | |
| TPM | | |
| Modo de arranque | | |
| Configuración de virtualización | | |

## 3. Sistema anfitrión y entorno de virtualización

### 3.1. Software instalado

| Software | Versión | Función |
|---|---|---|
| Linux Mint | 22.3 | Sistema operativo anfitrión |
| Oracle VirtualBox | 7.0.20 | Gestión de máquinas virtuales |
| Git | 2.43.0 | Control de versiones |
| GitHub CLI | 2.45.0 | Gestión del repositorio |
| Otros | | |

### 3.2. Configuración de las máquinas virtuales

| Máquina virtual | Sistema invitado | RAM | CPU virtuales | Disco virtual | Red | Estado |
|---|---|---:|---:|---:|---|---|
| Debian 13.1 | Debian GNU/Linux 13.1 | 2048 MB | 1 | 20 GB | NAT | Registrada; problema de arranque pendiente |
| W11 | Windows 11 | 4096 MB | 2 | 80 GB | NAT | Registrada; instalación pendiente de verificar |

### 3.3. Características adicionales de las máquinas virtuales

| Característica | Debian 13.1 | W11 |
|---|---|---|
| Firmware virtual | BIOS | EFI |
| Controlador gráfico | VMSVGA | VBoxSVGA |
| Memoria de vídeo | 128 MB | 128 MB |
| Aceleración 3D | Desactivada | Desactivada |
| TPM 2.0 | | Configurado |
| Secure Boot | | Configurado |
| Virtualización anidada | Desactivada | Desactivada |
| Estado de la instalación | Pendiente de resolver el arranque | Pendiente de verificar |

### 3.4. Organización de la red virtual

| Elemento | Configuración | Observaciones |
|---|---|---|
| Adaptador de red de Debian | NAT | |
| Adaptador de red de Windows 11 | NAT | |
| Red interna del laboratorio | | Pendiente de configurar |
| Rango de direcciones IP | | Pendiente de definir |
| Servidor DHCP | | Pendiente de configurar |
| Comunicación entre máquinas virtuales | | Pendiente de verificar |

## 4. Diagnósticos y pruebas de rendimiento (Apte+)

Las pruebas se realizarán con las condiciones de ejecución documentadas, evitando que las máquinas virtuales u otros procesos alteren los resultados. Se registrarán las herramientas utilizadas, los resultados y su interpretación.

### 4.1. Diagnóstico de almacenamiento

| Prueba | Herramienta | Condiciones | Resultado | Interpretación |
|---|---|---|---|---|
| Identificación de discos | `lsblk` | | | |
| Espacio ocupado | `df -h` | | | |
| Escritura secuencial | | | | |
| Lectura secuencial | | | | |
| Escritura aleatoria | | | | |
| Salud del disco | `smartctl` | | | |

### 4.2. Diagnóstico de memoria

| Prueba | Herramienta | Condiciones | Resultado | Interpretación |
|---|---|---|---|---|
| Memoria total y disponible | `free -h` | | | |
| Información de módulos | `dmidecode` | | | |
| Prueba de memoria | | | | |
| Comprobación de errores | | | | |

### 4.3. Diagnóstico de red

| Prueba | Herramienta | Condiciones | Resultado | Interpretación |
|---|---|---|---|---|
| Identificación de interfaces | `ip a` | | | |
| Velocidad de enlace | | | | |
| Conectividad local | `ping` | | | |
| Conectividad a Internet | | | | |
| Velocidad de transferencia | | | | |

### 4.4. Temperatura y consumo de recursos

| Prueba | Herramienta | Condiciones | Resultado | Interpretación |
|---|---|---|---|---|
| Temperatura en reposo | | | | |
| Temperatura bajo carga | | | | |
| Uso de CPU | | | | |
| Uso de RAM | | | | |
| Uso de disco | | | | |

## 5. Limitaciones, cuellos de botella y propuestas de mejora

| Nº | Limitación detectada | Evidencia | Posible consecuencia | Propuesta de mejora |
|---|---|---|---|---|
| 1 | Memoria RAM disponible: 30 GiB | | Limita el número de máquinas virtuales simultáneas | Ejecutar escenarios de forma selectiva |
| 2 | Almacenamiento del laboratorio en SSD externo | | | |
| 3 | Virtualización anidada pendiente de verificar | | Puede afectar a las pruebas con Proxmox VE | |
| 4 | | | | |
| 5 | | | | |

## 6. Evidencias y registros del inventario

Las comprobaciones realizadas se acompañarán de capturas de pantalla, salidas de terminal y registros de las herramientas utilizadas.

| Evidencia | Archivo | Estado |
|---|---|---|
| Información general del hardware | | Pendiente |
| Procesador y virtualización | | Pendiente |
| Memoria RAM | | Pendiente |
| Discos y particiones | | Pendiente |
| Interfaces de red | | Pendiente |
| Firmware y arranque | | Pendiente |
| Configuración de VirtualBox | | Pendiente |
| Diagnóstico de almacenamiento | | Pendiente |
| Diagnóstico de memoria | | Pendiente |
| Diagnóstico de red | | Pendiente |

## 7. Conclusiones del inventario

El equipo individual dispone de un procesador Intel Core Ultra 5 125H, 30 GiB de memoria RAM y un SSD externo de 931,5 GB donde se encuentra instalado Linux Mint 22.3 y se desarrolla el laboratorio de virtualización.

La configuración permite trabajar con diferentes sistemas operativos y servicios mediante VirtualBox. No obstante, la ejecución simultánea de todas las máquinas virtuales deberá limitarse en función de los recursos disponibles.

La valoración definitiva del rendimiento, las posibles limitaciones del almacenamiento y la capacidad de ejecución de los distintos escenarios se establecerán una vez completadas las pruebas y diagnósticos.

**Estado final del inventario:** Pendiente de completar las comprobaciones técnicas y adjuntar las evidencias correspondientes.
