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
        $deviceCount = (cmd /c $iMobileDeviceFolder\idevice_id.exe -l).Count
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
