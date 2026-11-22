# copia-ad.ps1 — srv-dc: copia de Active Directory al NAS (nas-truenas) por SCP con clave
# Qué se copia: base de datos de AD (ntds.dit) + SYSVOL (GPO y scripts) + registro (SYSTEM/SECURITY) con «ntdsutil ifm»
#               y la lista de usuarios, grupos y GPO en texto. NO se copia la imagen del sistema (50 GB): se reinstala.
$ErrorActionPreference = "Stop"
Start-Transcript -Path "C:\ProgramData\copias\ultima-copia.log" -Force | Out-Null
# Tras un reinicio, AD Web Services tarda en estar disponible: esperar hasta 5 min antes de copiar
$limite = (Get-Date).AddMinutes(5)
while ($true) { try { Get-ADDomain -ErrorAction Stop | Out-Null; break } catch { if ((Get-Date) -gt $limite) { throw "AD no responde tras 5 min" }; Start-Sleep 10 } }
$fecha = Get-Date -Format "yyyyMMdd-HHmm"
$base  = "C:\ProgramData\copias"; $tmp = "$base\ifm-$fecha"; $zip = "$base\srv-dc-ad-$fecha.zip"
New-Item -ItemType Directory -Force $tmp | Out-Null
ntdsutil "activate instance ntds" "ifm" "create sysvol full $tmp\ifm" quit quit | Out-Null
Get-ADUser -Filter * -Properties Department,MemberOf | Select-Object SamAccountName,Enabled,Department,DistinguishedName | Export-Csv "$tmp\usuarios.csv" -NoTypeInformation -Encoding UTF8
Get-ADGroup -Filter * | Select-Object Name,GroupScope,DistinguishedName | Export-Csv "$tmp\grupos.csv" -NoTypeInformation -Encoding UTF8
Backup-GPO -All -Path (New-Item -ItemType Directory -Force "$tmp\gpo").FullName | Out-Null
Compress-Archive -Path "$tmp\*" -DestinationPath $zip -Force
(Get-FileHash $zip -Algorithm SHA256).Hash.ToLower() + "  " + (Split-Path $zip -Leaf) | Set-Content "$zip.sha256" -Encoding ascii
& scp.exe -q -i "$base\copia_nas" -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile="$base\known_hosts" $zip "$zip.sha256" "c-srvdc@192.168.29.10:/mnt/copias/srv-dc/"
if ($LASTEXITCODE -ne 0) { throw "scp falló ($LASTEXITCODE)" }
Remove-Item $tmp -Recurse -Force
Get-ChildItem "$base\srv-dc-ad-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -Skip 7 | ForEach-Object { Remove-Item $_.FullName, "$($_.FullName).sha256" -Force }
"OK: $(Split-Path $zip -Leaf) ($([math]::Round((Get-Item $zip).Length/1MB,1)) MB) subida a c-srvdc@nas-truenas"
Stop-Transcript | Out-Null
