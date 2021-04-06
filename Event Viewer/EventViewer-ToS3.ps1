## Maybe have, if no serial number then do hostname, better than the huge name. ##
$hostname = hostname
$yesterday = (Get-Date) - (New-TimeSpan -Day 1)
$serialnumber = (Get-WmiObject win32_bios | select Serialnumber).serialnumber

$appeventlogs = "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" + $hostname + "-App-EV-Logs-" + $serialnumber + ".txt"
$systeventlogs = "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" + $hostname + "-Syst-EV-Logs-" + $serialnumber + ".txt"

Get-WinEvent -LogName 'Application' -ErrorAction SilentlyContinue | Where-Object { $_.TimeCreated -ge $Yesterday } -ErrorAction SilentlyContinue | Out-File $appeventlogs -ErrorAction SilentlyContinue
Get-WinEvent -LogName 'System' -ErrorAction SilentlyContinue | Where-Object { $_.TimeCreated -ge $Yesterday } -ErrorAction SilentlyContinue | Out-File $systeventlogs -ErrorAction SilentlyContinue

## Write to S3 Bucket ##
$key1 = $hostname + "-App-EV-Logs-" + $serialnumber + ".txt"
$key2 = $hostname + "-Syst-EV-Logs-" + $serialnumber + ".txt"

Set-AWSCredential -ProfileName Ems-SvcAccount
Write-S3Object -BucketName event-viewer-logs -File $systeventlogs
Write-S3Object -BucketName event-viewer-logs -File $appeventlogs