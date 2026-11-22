# 2026-11-22 17:59:54 by RouterOS 7.24.5
# system id = k0QWBAuRq+N
#
/interface ethernet
set [ find default-name=ether1 ] comment=WAN-NAT-VirtualBox \
    disable-running-check=no
set [ find default-name=ether2 ] comment=LAN-lan-iso disable-running-check=no
/ip pool
add name=pool-lan ranges=192.168.29.100-192.168.29.200
/ip address
add address=192.168.29.1/24 comment=LAN interface=ether2 network=192.168.29.0
/ip dhcp-client
add interface=ether1 name=client1
/ip dhcp-server
# Interface not running
add address-pool=pool-lan interface=ether2 lease-time=8h name=dhcp-lan
/ip dhcp-server network
add address=192.168.29.0/24 dns-server=192.168.29.1 domain=iso29.lan gateway=\
    192.168.29.1
/ip dns
set allow-remote-requests=yes
/ip firewall filter
add action=drop chain=input comment=No-DNS-desde-WAN dst-port=53 \
    in-interface=ether1 protocol=udp
add action=accept chain=forward comment=Permitir-HTTPS dst-port=443 \
    in-interface=ether2 log=yes log-prefix=PERMITIDO-HTTPS protocol=tcp
add action=drop chain=forward comment=Bloquear-HTTP dst-port=80 in-interface=\
    ether2 log=yes log-prefix=BLOQUEO-HTTP protocol=tcp
/ip firewall nat
add action=masquerade chain=srcnat comment=NAT-salida-LAN out-interface=\
    ether1
/ip ssh
set forwarding-enabled=local
/system clock
set time-zone-name=Europe/Madrid
/system identity
set name=r-mikrotik

