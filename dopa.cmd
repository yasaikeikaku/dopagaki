@echo off
setlocal

set "QUERY=%*"
set "PLAYER=%~dp0dopa-player.ps1"

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'Stop';" ^
  "$config = Join-Path $env:USERPROFILE '.dopa-track.txt';" ^
  "$pidFile = Join-Path $env:TEMP 'dopa-player.pid';" ^
  "$track = $env:DOPA_TRACK;" ^
  "if (-not $track -and (Test-Path -LiteralPath $config)) { $track = (Get-Content -LiteralPath $config -Raw).Trim() }" ^
  "if ($track -and (Test-Path -LiteralPath $track)) {" ^
  "  $me = $PID;" ^
  "  $pattern = '(?i)powershell(?:\.exe)?\"?\s+-NoProfile\s+-ExecutionPolicy\s+Bypass\s+-File\s+\"?.*dopa-player\.ps1';" ^
  "  Get-CimInstance Win32_Process | Where-Object { $_.ProcessId -ne $me -and $_.Name -like 'powershell*' -and $_.CommandLine -match $pattern } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue };" ^
  "  if (Test-Path -LiteralPath $pidFile) {" ^
  "    $oldPid = (Get-Content -LiteralPath $pidFile -Raw).Trim();" ^
  "    if ($oldPid -match '^\d+$') {" ^
  "      $old = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $oldPid) -ErrorAction SilentlyContinue;" ^
  "      if ($old -and $old.CommandLine -like '*dopa-player.ps1*') { Stop-Process -Id ([int]$oldPid) -Force -ErrorAction SilentlyContinue }" ^
  "    }" ^
  "  }" ^
  "  $player = '%PLAYER%';" ^
  "  $playerArg = '\"' + ($player -replace '\"', '\\\"') + '\"';" ^
  "  $trackArg = '\"' + ($track -replace '\"', '\\\"') + '\"';" ^
  "  $args = '-NoProfile -ExecutionPolicy Bypass -File ' + $playerArg + ' -Path ' + $trackArg;" ^
  "  $proc = Start-Process -FilePath 'powershell.exe' -ArgumentList $args -WindowStyle Hidden -PassThru;" ^
  "  Set-Content -LiteralPath $pidFile -Value $proc.Id -Encoding ASCII;" ^
  "  exit 0;" ^
  "}" ^
  "$query = '%QUERY%';" ^
  "if ($query) { $encoded = [uri]::EscapeDataString($query); Start-Process ('https://www.youtube.com/results?search_query=' + $encoded); exit 0 }" ^
  "Start-Process 'https://www.youtube.com/results?search_query=%E3%81%82%E3%81%95%E3%81%AE%E3%81%B2%E3%81%8B%E3%82%8A%E3%81%AE%E4%B8%AD%E3%81%A7';"
