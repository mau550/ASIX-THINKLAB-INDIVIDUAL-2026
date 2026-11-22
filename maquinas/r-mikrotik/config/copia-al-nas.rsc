# copia-al-nas.rsc — r-mikrotik: copia diaria (backup cifrado + export) al NAS por SFTP
# En el repositorio las contraseñas aparecen como CLAVE_CIFRADO y CLAVE_SFTP (se sustituyen al instalar).
# NOTA (INC-006): /tool fetch no parte del directorio personal del usuario SFTP; dst-path debe ser ABSOLUTA (si no: <sftp status: 4>).
/system script add name=copia-al-nas policy=read,write,policy,test,sensitive,ftp source={
  :local d [/system clock get date]
  :local f ("r-mikrotik-" . [:pick $d 0 4] . [:pick $d 5 7] . [:pick $d 8 10])
  /system backup save name=$f password="CLAVE_CIFRADO"
  /export file=$f
  :delay 3s
  /tool fetch upload=yes mode=sftp address=192.168.29.10 user=c-mikrotik password="CLAVE_SFTP" src-path=($f . ".backup") dst-path=("/mnt/copias/r-mikrotik/" . $f . ".backup")
  /tool fetch upload=yes mode=sftp address=192.168.29.10 user=c-mikrotik password="CLAVE_SFTP" src-path=($f . ".rsc") dst-path=("/mnt/copias/r-mikrotik/" . $f . ".rsc")
  :log info ("copia-al-nas: " . $f . " subida a nas-truenas")
}
/system scheduler add name=copia-diaria start-time=02:30:00 interval=1d on-event="/system script run copia-al-nas" comment="Copia diaria al NAS"
