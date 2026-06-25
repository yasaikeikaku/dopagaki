@echo off
setlocal

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'SilentlyContinue';" ^
  "$pidFile = Join-Path $env:TEMP 'dopa-player.pid';" ^
  "if (Test-Path -LiteralPath $pidFile) {" ^
  "  $savedPid = (Get-Content -LiteralPath $pidFile -Raw).Trim();" ^
  "  if ($savedPid -match '^\d+$') {" ^
  "    $proc = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $savedPid);" ^
  "    if ($proc -and $proc.CommandLine -like '*dopa-player.ps1*') { Stop-Process -Id ([int]$savedPid) -Force }" ^
  "  }" ^
  "  Remove-Item -LiteralPath $pidFile -Force;" ^
  "}" ^
  "$me = $PID;" ^
  "$pattern = '(?i)powershell(?:\.exe)?\"?\s+-NoProfile\s+-ExecutionPolicy\s+Bypass\s+-File\s+\"?.*dopa-player\.ps1';" ^
  "Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -ne $me -and $_.Name -like 'powershell*' -and $_.CommandLine -match $pattern } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force };"
