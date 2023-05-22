param ($Mode='None', $monitorAltserverInterval=30, $monitoriDeviceInterval=60, $iMobileDeviceFolder="imobiledevice", $altServerPath="C:\Program Files (x86)\AltServer\AltServer.exe", $appleServiceName="Apple Mobile Device Service")
$version = "1.0"

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
# MIIFiQYJKoZIhvcNAQcCoIIFejCCBXYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU7GfPsOYAjrHjMFc5Gl1Z88/t
# 4t6gggMkMIIDIDCCAgigAwIBAgIQGNH7plKC6LVFUlETt7lKCTANBgkqhkiG9w0B
# AQsFADAaMRgwFgYDVQQDDA9kaXNjb3JkLmRpZ2l0YWwwHhcNMjEwNDI0MTUwMzEz
# WhcNMzEwNDI0MTUxMzEzWjAaMRgwFgYDVQQDDA9kaXNjb3JkLmRpZ2l0YWwwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDb2l+dd8BVycmH3loxYUITJSTT
# ooEk7qDt04Kf0egkci9GAA+DUsl92CNTIof5b+MOkNB2rjBnXPfE2SkIAcO3GowV
# /qnqMsCw01N9AsQyJLW347NlBjTYSy4hueh/GLzWOilKmC1w070qKxpSzQSHj7jj
# uTelbx371j/iqra9Fqunhxst0/9jJ2l2gIcvl7Mae8r8+bHj4adMnzQMWq3VWA/p
# 8YvQFmTruPav00sM+4rZUT8tnUM7Soqf4PHnIuzAd7pOiKm7/qpeTGq1DAvbu4/e
# M52RDocJ1mQflpjezNMI832bVX2m+o4D40Rvvkw8sG8mV2UALmuB2+Im4cppAgMB
# AAGjYjBgMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAaBgNV
# HREEEzARgg9kaXNjb3JkLmRpZ2l0YWwwHQYDVR0OBBYEFBF78p0EeyCrLVRK44zI
# W/BonnM0MA0GCSqGSIb3DQEBCwUAA4IBAQC48fjKBHW5ffDRvqGbzdDt0/p/t8bM
# rnOBe0nA9t3nMMymY7wYeucCmLt+pdDOks3j1oghG0B1Owg+oIR/DaDebJgtkrV2
# K43bdnHTi97rw4MpwY2156yrAgL8L5Q/E4m8KmtI8XAlwd+GbEmdgTa/2y9/dEfV
# hRsoeUbwJG3GoDhwxvKy8FeylPnwuNX/vFagbnUMXeTu1Yj9FcZmXwUhX49kCifk
# qmMoG1g8O5E23SwDqdjKu+8ZLdgzq8dDpSjZrhk7YKS674zPE/NhCTc5uwVRyJf5
# cLRh1UIQTyMTT1EyVUuoZ/NQ7WBKLqk+RRoHVm0Z3N5/U32nBlTZ7CmtMYIBzzCC
# AcsCAQEwLjAaMRgwFgYDVQQDDA9kaXNjb3JkLmRpZ2l0YWwCEBjR+6ZSgui1RVJR
# E7e5SgkwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFPLL9sseLobSKzH9qTBCRBrLiCyLMA0GCSqG
# SIb3DQEBAQUABIIBAJ17vnkMwyDRWIMf84C4z6AnFl+nEpxzwM2VlcDpyodXsd4F
# 7mlBXtxFe+PY8gDBz/PLslR6QTBb0dxMbVZFVS1RzZgYAzA0z9thTKEqoe3cvR1m
# u77bAOnaJJ6m75gz9th72CYEOAcWvnaRaQxcp0AiSPycXmc6zVgVt+E36wPjiS5g
# 3l8aIKnf5srPWo1zU+cBMmlEpJASIojLVeCp/OqdIEaqgHepcIf/qj7w5/EjtkuW
# Q4dV7cAahqgElt5nIGI1ISMUv/Knxe+UAQBT5SSM/H8uEXuypkAroqCNGrqj5xuF
# qsx4FM/Y/X58NeWqew64KCli+taylu5BNmP3t/c=
# SIG # End signature block
