# copia-cli-win11.ps1 — copia de los DATOS de usuario y de la CONFIGURACIÓN de cli-win11 al NAS
# Se ejecuta cada día a las 02:30 como SYSTEM (tarea programada "Copia al NAS").
# Qué se copia: Documentos, Escritorio e Imágenes de cada usuario + un informe de configuración
#   (red, programas instalados, usuarios y grupos, dominio). Qué NO se copia: Windows ni los
#   programas (se reinstalan desde la ISO o una imagen maestra), ni temporales y cachés.
$ErrorActionPreference = 'Stop'
$base  = 'C:\ProgramData\copias'
$fecha = Get-Date -Format 'yyyyMMdd-HHmm'
$nom   = "cli-win11-$fecha"
$tmp   = Join-Path $env:TEMP $nom
$zip   = "$tmp.zip"
$log   = "$base\copia.log"
New-Item -ItemType Directory "$tmp\usuarios", "$tmp\configuracion" -Force | Out-Null
try {
  foreach ($u in Get-ChildItem C:\Users -Directory | Where-Object { $_.Name -notin 'Public','Default','Default User','All Users' }) {
    foreach ($c in 'Documents','Desktop','Pictures') {
      $src = Join-Path $u.FullName $c
      if (Test-Path $src) { robocopy $src "$tmp\usuarios\$($u.Name)\$c" /E /R:1 /W:1 /XJ /NFL /NDL /NJH /NJS | Out-Null }
    }
  }
  $cfg = "$tmp\configuracion"
  ipconfig /all            > "$cfg\red-ipconfig.txt"
  Get-NetIPConfiguration | Out-String -Width 160 > "$cfg\red-netipconfiguration.txt"
  Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue |
    Where-Object DisplayName | Sort-Object DisplayName | Select-Object DisplayName,DisplayVersion,Publisher |
    Export-Csv "$cfg\programas-instalados.csv" -NoTypeInformation -Encoding UTF8
  Get-LocalUser | Select-Object Name,Enabled,Description | Export-Csv "$cfg\usuarios-locales.csv" -NoTypeInformation -Encoding UTF8
  net localgroup Administradores > "$cfg\grupo-administradores.txt"
  Get-CimInstance Win32_ComputerSystem | Select-Object Name,Domain,PartOfDomain | Format-List > "$cfg\equipo-dominio.txt"
  Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber | Format-List > "$cfg\version-windows.txt"
  Compress-Archive -Path "$tmp\*" -DestinationPath $zip -Force
  $h = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
  "$h  $nom.zip" | Out-File "$zip.sha256" -Encoding ascii
  $ssh = @('-i', "$base\copia-cli-win11", '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=accept-new', '-o', "UserKnownHostsFile=$base\known_hosts")
  & scp.exe @ssh $zip "$zip.sha256" 'c-cliwin11@192.168.29.10:/mnt/copias/cli-win11/'
  if ($LASTEXITCODE -ne 0) { throw "scp terminó con código $LASTEXITCODE" }
  # Retención: se conservan las 7 copias más recientes en el NAS
  & ssh.exe @ssh c-cliwin11@192.168.29.10 'cd /mnt/copias/cli-win11 && ls -1t cli-win11-*.zip | tail -n +8 | while read f; do rm -f $f $f.sha256; done'
  "$(Get-Date -Format s) OK: $nom.zip ($([math]::Round((Get-Item $zip).Length/1KB)) KB) sha256=$h subida a c-cliwin11@192.168.29.10" | Add-Content $log
} catch {
  "$(Get-Date -Format s) ERROR: $_" | Add-Content $log
  exit 1
} finally {
  Remove-Item $tmp, $zip, "$zip.sha256" -Recurse -Force -ErrorAction SilentlyContinue
}
