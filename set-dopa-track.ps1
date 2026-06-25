param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path
)

$ErrorActionPreference = "Stop"
$resolved = Resolve-Path -LiteralPath $Path
$config = Join-Path $env:USERPROFILE ".dopa-track.txt"

Set-Content -LiteralPath $config -Value $resolved.Path -Encoding UTF8
Write-Host "Set dopa audio file:"
Write-Host "  $($resolved.Path)"
