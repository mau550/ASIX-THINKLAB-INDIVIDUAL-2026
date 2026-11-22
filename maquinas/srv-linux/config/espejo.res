# /etc/drbd.d/espejo.res — espejo de discos entre srv-linux y srv-linux2 (DRBD, «RAID 1 por red»)
resource espejo {
    protocol C;                      # síncrono: una escritura no se da por buena hasta que está en los DOS nodos
    net {
        after-sb-0pri discard-zero-changes;   # tras un corte, si un lado no cambió nada, se resincroniza solo
    }
    on srv-linux {
        device    /dev/drbd0;
        disk      "/dev/disk/by-path/pci-0000:00:0d.0-ata-6";   # disco dedicado de 1 GB (sdd)
        address   192.168.29.14:7789;
        meta-disk internal;
    }
    on srv-linux2 {
        device    /dev/drbd0;
        disk      "/dev/disk/by-path/pci-0000:00:0d.0-ata-2";   # disco dedicado de 1 GB (sdb)
        address   192.168.29.16:7789;
        meta-disk internal;
    }
}
