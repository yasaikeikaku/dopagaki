$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "dopa.cmd"
if (-not (Test-Path -LiteralPath $source)) {
    throw "dopa.cmd was not found: $source"
}

$binDir = Join-Path $env:LOCALAPPDATA "Programs\dopa-bin"
New-Item -ItemType Directory -Force -Path $binDir | Out-Null

$files = @("dopa.cmd", "nodopa.cmd", "dopa-player.ps1")
foreach ($file in $files) {
    $path = Join-Path $PSScriptRoot $file
    if (-not (Test-Path -LiteralPath $path)) {
        throw "$file was not found: $path"
    }

    Copy-Item -LiteralPath $path -Destination (Join-Path $binDir $file) -Force
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = @()
if ($userPath) {
    $pathParts = $userPath -split ";" | Where-Object { $_ }
}

if ($pathParts -notcontains $binDir) {
    $newPath = (($pathParts + $binDir) -join ";")
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Added to PATH: $binDir"
    Write-Host "Open a new terminal, then run: dopa"
} else {
    Write-Host "PATH already contains: $binDir"
}

Write-Host ""
Write-Host "To set your local audio file:"
Write-Host '  .\set-dopa-track.ps1 "C:\path\to\song.mp3"'
Write-Host ""
Write-Host "Without a configured file, dopa opens the YouTube search page."
Write-Host "Use nodopa to stop local audio playback."
