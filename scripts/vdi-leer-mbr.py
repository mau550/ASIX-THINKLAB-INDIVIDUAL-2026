#!/usr/bin/env python3
"""Lee en SOLO LECTURA el MBR de un disco VDI dinámico de VirtualBox (INC-001).
Uso: python3 vdi-leer-mbr.py "disco.vdi"   (con la VM apagada)"""
import struct,sys
f=open(sys.argv[1],'rb')
h=f.read(512)
hdr_size=struct.unpack('<I',h[0x48:0x4c])[0]
imgtype=struct.unpack('<I',h[0x4c:0x50])[0]
off_blocks=struct.unpack('<I',h[0x154:0x158])[0]
off_data=struct.unpack('<I',h[0x158:0x15c])[0]
disk_size=struct.unpack('<Q',h[0x170:0x178])[0]
block_size=struct.unpack('<I',h[0x178:0x17c])[0]
nblocks=struct.unpack('<I',h[0x180:0x184])[0]
print("type",imgtype,"size",disk_size,"bs",block_size,"blocks",nblocks)
f.seek(off_blocks); bmap=struct.unpack('<%dI'%nblocks,f.read(4*nblocks))
alloc=sum(1 for b in bmap if b!=0xffffffff); print("alloc blocks",alloc)
def read(off,n):
    out=b''
    while n>0:
        bi=off//block_size; bo=off%block_size; k=min(n,block_size-bo)
        e=bmap[bi]
        if e==0xffffffff: out+=b'\0'*k
        else: f.seek(off_data+e*block_size+bo); out+=f.read(k)
        off+=k;n-=k
    return out
mbr=read(0,512)
print("MBR sig",mbr[510:512].hex(),"boot code nonzero:",any(mbr[:440]), "GRUB" in str(mbr[:440]))
for i in range(4):
    p=mbr[446+16*i:462+16*i]; t=p[4]; lba,cnt=struct.unpack('<II',p[8:16])
    if t: print("part",i+1,"boot=%02x"%p[0],"type=%02x"%t,"start",lba,"sectors",cnt,"=%.1f GB"%(cnt*512/1e9))
gpt=read(512,512); print("GPT header:",gpt[:8])
if gpt[:8]==b'EFI PART':
    ent_lba,nent,esz=struct.unpack('<QII',gpt[72:88])
    ents=read(ent_lba*512,nent*esz)
    for i in range(nent):
        e=ents[i*esz:(i+1)*esz]
        if any(e[:16]):
            import uuid
            print("gpt part",i+1,uuid.UUID(bytes_le=e[:16]),struct.unpack('<QQ',e[32:48]),e[56:128].decode('utf-16le').rstrip('\0'))
# check ext4 superblocks / ESP in partitions
import re
print("MBR strings:",re.findall(rb'[ -~]{4,}',mbr[:446]))
core=read(512,2047*512)
print("core.img area nonzero bytes:",sum(1 for b in core if b), re.findall(rb'[ -~]{6,}',core)[:15])
# ext4 superblock of part1
sb=read(2048*512+1024,1024)
print("ext magic",sb[0x38:0x3a].hex(),"label",sb[0x78:0x88],"last mounted",sb[0x88:0xc8].rstrip(b'\0'))
import time
print("mtime",time.ctime(struct.unpack('<I',sb[0x2c:0x30])[0]),"wtime",time.ctime(struct.unpack('<I',sb[0x30:0x34])[0]),"mount count",struct.unpack('<H',sb[0x34:0x36])[0])
