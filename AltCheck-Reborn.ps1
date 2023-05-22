param ($Mode='None', $monitorAltserverInterval=30, $monitoriDeviceInterval=60, $iMobileDeviceFolder="imobiledevice", $altServerPath="C:\Program Files (x86)\AltServer\AltServer.exe", $appleServiceName="Apple Mobile Device Service")
$version = "1.1"

Set-Location -Path $PsScriptRoot

if ($Mode -eq "None") {
    Write-Host AltCheck-Reborn Version $version
    Write-Host
    Write-Host Syntax:
    Write-Host        AltCheck-Reborn -Mode serviceMonitor
    Write-Host        AltCheck-Reborn -Mode checkAltServer
    Write-Host
    Write-Host Grab the latest version on GitHub: https://github.com/DiscordDigital
}

function startAltServer {
    Write-Host [ACTION] Started AltServer
    Start-Process $altServerPath
}

function checkAltServer {
    $process = Get-Process AltServer -ErrorAction SilentlyContinue
    if ($process) {
        return $true;
    } else {
        return $false;
    }
}

function restartAppleMobileDeviceService {
    Write-Host [INFO] Restarting $appleServiceName
    try {
        Restart-Service -Name $appleServiceName -ErrorAction Stop
        Write-Host [OK] Action completed
        Write-Host [INFO] To give $appleServiceName time to detect your iPhone, waiting now for $monitoriDeviceInterval seconds..
    } catch {
        Write-Host "[ERROR] Can't restart $appleServiceName. Try running this script as Administrator." 
        Write-Host [INFO] Waiting $monitoriDeviceInterval seconds before attempting again.
    }
    Start-Sleep $monitoriDeviceInterval
}

if ($Mode -eq "serviceMonitor") {
    while($true) {
        $deviceCount = ("$iMobileDeviceFolder\idevice_id.exe -l" | Measure-Object).Count
        if ($deviceCount -eq "0") {
            Write-Host [WARN] No devices found. Restarting $appleServiceName.
            restartAppleMobileDeviceService
        } else {
            Write-Host "[INFO] $deviceCount device(s) found, no action needed."
            Write-Host [INFO] Waiting for $monitoriDeviceInterval seconds before checking again.
            Start-Sleep $monitoriDeviceInterval
        }
       
    }
}

if ($Mode -eq "checkAltServer") {
    while($true) {
        $altServerStatus = checkAltServer
        if ($altServerStatus) {
            Write-Host [INFO] AltServer is running
        } else {
            Write-Host "[INFO] AltServer isn't running.. Calling startAltServer"
            startAltServer
        }
        Write-Host [INFO] Waiting $monitorAltserverInterval seconds before checking again!
        Start-Sleep $monitorAltserverInterval
    }
}
# SIG # Begin signature block
# MIIFagYJKoZIhvcNAQcCoIIFWzCCBVcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU5fDipQml1ndZlTSiEtdoxkEA
# CEegggMGMIIDAjCCAeqgAwIBAgIQRepdUuBPxJhMIbp9MUnzPjANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5EaXNjb3JkRGlnaXRhbDAeFw0yMzA1MjIxODQ0MDNa
# Fw0yNDA1MjIxOTA0MDNaMBkxFzAVBgNVBAMMDkRpc2NvcmREaWdpdGFsMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+Y9hBzffu65+8Cng2gUQ1yIjVPnF
# MLD1bsJ8bn6ztYWuIa63OLOE747RxXoZCDYIpIBdomFqvFrw0jVAnnM4uAOfY28L
# 5BTvNRbmEmHKhcIi42PKcLQFnd0AaqN6QtbQVITsTxzLjJGHn7H70CBhTyUY36un
# /+6v5JzOkmTPPPP8I9CTDIfM8Zdx/goIViBpSEDUJ8jATVSgwPaMxcAhu4f42La0
# MV/OJ3t8XM74EXT1rGq8GPcwWmhM3K+3l1ZaDPawCWikprPUXyRS84tsiQwNo8Ha
# 92iacCn5RNjgEmOp6iavzeaF1+AARb9btSIlNg3wpfCLy6UfysGPY6J4+QIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFLA7uuIY5wAW36T67YPUPP7DewFPMA0GCSqGSIb3DQEBCwUAA4IBAQDarheR
# +sekJ0fHuZYhtM6EqM91fUSdyknESQKw5s4SyY4meqBjypdlk491Q+sMvFTQ3kfx
# 1qe4hRQXqtykb7ybsEFqoeaA3MJas8f+7pV9r+IMFzUbCCMbZm5oPBzS+6GyGOol
# +nd8zCmyNHoE9rVldiBez8CcrJdyRVLHJw+lEbHDWsXLkb3e6NIg+Fk/VYoc3bqe
# xyFUrWNi46CSXMagEx2D6eOir8AnmYyDeQXCuYRI+OPl+HI1YuiMermDvo2Xm1qJ
# OGpUxWC/brmQ2tWvedMb2PTqxEEKyyCDf+pzywvL4zwDzqsW6KrTj7AttQov8SU/
# /IG8dkbwRxFb7OV1MYIBzjCCAcoCAQEwLTAZMRcwFQYDVQQDDA5EaXNjb3JkRGln
# aXRhbAIQRepdUuBPxJhMIbp9MUnzPjAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU1pZJlWViD5Og
# EeBk3s8B30Ett1wwDQYJKoZIhvcNAQEBBQAEggEA1o/C9KtsBiD0JbRZk4KeC7di
# ZcYVGwut1DP4b33SRPvpvqbhxnQr1+jkTg5XPfyMbuxYAL6u8luekBwjvYr+GO/5
# 2mbJXZQmiqLvbHggXCTh+ELExJwmOPzLV8oWSVdgecej+hKKRaprp14wagVq3SaX
# eNZRhFsxdV7aXrekAgacWai9mVzPMKPWcLgIh6XTKsNpPV2q8YA2Xr7DL0mayATm
# S/vteHywk4urx6qpSdmowDxkFHqPDPHzItRH4dFZV9mS72nWEkY7HDk10s5RDmAz
# 7h8fT4LL3uaR0vAzOCwy3I7DtBcEMKTwwhxuYiKxSxvSJCZJMUayRFzf9nalcA==
# SIG # End signature block
