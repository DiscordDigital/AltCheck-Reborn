# AltCheck-Reborn
A port of classic AltCheck for Windows into PowerShell, to improve stability and maintainability.

## ToDo to get this to work
1. Download iMobileDevice from the link at the bottom of this Readme.
2. Extract the zip file and name the folder "imobiledevice", make sure this folder is next to the AltCheck-Reborn.ps1 file.
3. Start PowerShell and type: Get-ExecutionPolicy\
If it doesn't output "RemoteSigned", you have to change it with "Set-ExecutionPolicy RemoteSigned".
4. Navigate with the PowerShell to the AltCheck-Reborn.ps1 file and run it once to see if it executes. ".\AltCheck-Reborn.ps1"\
When you get a prompt, make sure to "Always trust", so you can automate the launching of this file without confirmation every time.
5. Either create shortcuts yourself, or create two scheduled tasks.\
For scheduled tasks you have to launch powershell with following arguments:\
<path of AltCheck-Reborn.ps1> -Mode serviceMonitor\
<path of AltCheck-Reborn.ps1> -Mode checkAltServer
6. Always launch PowerShell as Administrator or elevated privileges, otherwise service restarts won't work.

## Optional parameters
The service monitor checks if the "Apple Mobile Device Service" is running.\
If the service ever gets renamed you can specify a different service name using the "-appleServiceName" parameter.

Following optional parameters are available:

-monitorAltserverInterval (How long it should wait between checks for AltServer.exe)\
-monitoriDeviceInterval (How long it should wait between checks for the detection of iOS devices)\
-iMobileDeviceFolder (Relative folder name of the folder containing iMobileDevice binaries)\
-altServerPath (Path of AltServer.exe)\
-appleServiceName (Name of the Apple Mobile Device Service)

## iMobileDevice download
Quamotion iMobileDevice for 64-bit: http://docs.quamotion.mobi/docs/imobiledevice/download/
