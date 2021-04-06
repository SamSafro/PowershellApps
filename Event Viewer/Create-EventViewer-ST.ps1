##Grab Logged in user for scheduled task creation.##
$loggedinuser = (Get-WmiObject -Class Win32_Process -Filter 'Name="explorer.exe"').GetOwner().User 
If ($null -eq $LoggedInUser) {$LoggedInUser = "fwiplayer"}


## If scheduled task exists, S3 Uploading already deployed. Exit in a good state ##
if (Get-ScheduledTask -TaskName "EventViewerUpload") { 
    echo "<-Start Result->"
    echo "Result=Event Viewer Already Exists”
    echo "<-End Result->"
    exit 0
    }

## If machine is lacking crucial command lets, exit in a good state ##
$checkst = Get-Command Get-ScheduledTask -ErrorVariable nocmdlet
if ($nocmdlet) {
    echo "<-Start Result->"
    echo "Result=Lacking Proper Powershell CMDlets”
    echo "<-End Result->"
    exit 0
     }

##Creating Scheduled task to run Event Viewer task every 5 minutes ##
##The interval can easily be changed right after /mo ##
& "$env:windir\system32\schtasks.exe" /create /sc minute /mo 5 /tn EventViewerUpload /tr powershell.exe /RU $LoggedInUser /f


##Adjust the action, and the argument, to call powershell and point to script.##
$Task = "EventViewerUpload"
$elegant_argument = "-windowstyle hidden -Command `"& 'C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\EventViewer-ToS3.ps1'`""
$Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument $elegant_argument
Set-ScheduledTask -TaskName $Task -Action $Action -User "NT AUTHORITY\SYSTEM"


## Place Event Viewer Upload script in Fwi Rmm Scripts folder ##
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
if (Test-Path "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts") {
Move-Item -Path $ScriptDir\EventViewer-ToS3.ps1 -Destination "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" -ErrorAction SilentlyContinue
} else {
New-Item -Path "C:\Users\Public\Documents\Four Winds Interactive\" -Name "FWI-RMMScripts" -ItemType "directory"
Move-Item -Path $ScriptDir\EventViewer-ToS3.ps1 -Destination "C:\Users\Public\Documents\Four Winds Interactive\FWI-RMMScripts\" -ErrorAction SilentlyContinue
}


## If this cmdlet isn't available then add aws cmdlets ##
$checkaws = Get-Command Set-AWSCredential -ErrorVariable noaws
## If there aren't AWS cmdlets, install them ##
if ($noaws) {
    ## Find modulepath locations and install in the first available ##
    $modulepath = $Env:PSModulePath
    $allpaths = $modulepath.Split(";")
    Write-Output $allpaths

    ## Unzip folder to module path ##\
    $awstools = "$ScriptDir\AWS.Tools.4.1.8.0.zip"
    $targetFolder = $allpaths[1]
    Expand-Archive -Literalpath $awstools -DestinationPath $targetFolder
     }

Set-AWSCredential -AccessKey AKIAYPNDMCMQYUWRWV65 -SecretKey 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 -StoreAs Ems-SvcAccount

##Check and exit accordingly for logging purposes.##
$taskcheck = Get-ScheduledTask -TaskName "EventViewerUpload" -ErrorAction SilentlyContinue
    If (!$taskcheck) { 
    echo "<-Start Result->"
    echo "Result=Failed To Create Event Viewer Task”
    echo "<-End Result->"
    exit 1
    }

echo "<-Start Result->"
echo "Result=Event Viewer Created”
echo "<-End Result->"
exit 0