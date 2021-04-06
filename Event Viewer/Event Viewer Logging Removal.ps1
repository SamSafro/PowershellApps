##This Script will completely remove the event viewer uploading from the machine ##
$hostname = hostname
$serialnumber = (Get-WmiObject win32_bios | select Serialnumber).serialnumber

$appeventlogs = "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" + $hostname + "-App-EV-Logs-" + $serialnumber + ".txt"
$systeventlogs = "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" + $hostname + "-Syst-EV-Logs-" + $serialnumber + ".txt"

Unregister-ScheduledTask -TaskName EventViewerUpload -Confirm:$false
Remove-Item -Path $appeventlogs
Remove-Item -Path $systeventlogs
Remove-Item -Path "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\EventViewer-ToS3.ps1" -Force