# Script: Task Scheduler ID upgrade
# Author: Gen Lee
# Date: 03/03/2017
# Updated 03/10/2017
Unregister-ScheduledTask -TaskName "id updater task" -Confirm:$false #Open-EID default scheduler
Unregister-ScheduledTask -TaskName "ID-updater" -Confirm:$false #Older automated Task Scheduler
if(Test-Path 'C:\Program Files\Open-EID\ID-updater.exe'){
    $soft='C:\Program Files\Open-EID\ID-updater.exe'
}
else{
    $soft='C:\Program Files (x86)\Open-EID\ID-updater.exe'
}
$restart_interval = (New-TimeSpan -Minutes 60)
$action = New-ScheduledTaskAction -Execute $soft -Argument '-autoupdate -autoclose'
$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 3 -RandomDelay "00:30" -At "11:15"
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -RestartCount 3 -RestartInterval $restart_interval

Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -User "SYSTEM" -RunLevel Highest `
    -TaskName "ID-updater 1.3" -Description "Updates ID card software"
