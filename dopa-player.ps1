param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = "Stop"

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class DopaMci {
    [DllImport("winmm.dll", CharSet = CharSet.Unicode)]
    public static extern int mciSendString(string command, StringBuilder returnValue, int returnLength, IntPtr winHandle);
}
"@

function Invoke-Mci {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,
        [int]$ReturnLength = 0
    )

    $buffer = $null
    if ($ReturnLength -gt 0) {
        $buffer = New-Object System.Text.StringBuilder $ReturnLength
    }

    $result = [DopaMci]::mciSendString($Command, $buffer, $ReturnLength, [IntPtr]::Zero)
    if ($result -ne 0) {
        throw "MCI command failed ($result): $Command"
    }

    if ($buffer) {
        return $buffer.ToString()
    }
}

$fullPath = (Resolve-Path -LiteralPath $Path).Path
$quotedPath = '"' + ($fullPath -replace '"', '""') + '"'

Invoke-Mci "open $quotedPath type mpegvideo alias dopa_track"

try {
    Invoke-Mci "play dopa_track"

    while ($true) {
        Start-Sleep -Milliseconds 500
        $mode = (Invoke-Mci "status dopa_track mode" 64).Trim()
        if ($mode -in @("stopped", "not ready")) {
            break
        }
    }
} finally {
    Invoke-Mci "stop dopa_track" | Out-Null
    Invoke-Mci "close dopa_track" | Out-Null
}
