## Pull event viewer logs easily ##
## Enter the machines hostmane, serial number and where you'd like to save the file ##

$EnterHostname = "3-VANGOGH1-V"

$EnterSerial = "I51-16-49297"

$localpath = 'C:\Windows\Temp\'




## Pulling from our Bucket here ##
$appeventlogs = $EnterHostname + "-App-EV-Logs-" + $EnterSerial + ".txt"
$systeventlogs = $EnterHostname + "-Syst-EV-Logs-" + $EnterSerial + ".txt"
Set-AWSCredential -AccessKey AKIAYPNDMCMQYUWRWV65 -SecretKey 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 -StoreAs Ems-SvcAccount
Set-AWSCredential -ProfileName Ems-SvcAccount
$bucket = 'event-viewer-logs'

$file = Get-S3Object -BucketName $bucket -KeyPrefix $appeventlogs
$localpath = 'C:\Windows\Temp\'
$localFileName = $appeventlogs
$localFilePath = Join-Path $localPath $localFileName
Copy-S3Object -BucketName $bucket -key $file.key -LocalFile $localFilePath

$file = Get-S3Object -BucketName $bucket -KeyPrefix $systeventlogs
$localpath = 'C:\Windows\Temp\'
$localFileName = $systeventlogs
$localFilePath = Join-Path $localPath $localFileName
Copy-S3Object -BucketName $bucket -key $file.key -LocalFile $localFilePath