# Script: Task Scheduler ID upgrade
# Author: Gen Lee
# Date: 03/03/2017

if(Test-Path 'C:\Program Files\Open-EID\ID-updater.exe'){
    $softver='C:\Program Files\Open-EID\ID-updater.exe'
}
else{
    $softver='C:\Program Files (x86)\Open-EID\ID-updater.exe'
}

$soft = New-ScheduledTaskAction -Execute $softver -Argument '-autoupdate -autoclose'
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable

Register-ScheduledTask -Action $soft -Trigger $trigger -Settings $settings `
    -TaskName "ID-updater" -Description "Updates ID card software at start up"
