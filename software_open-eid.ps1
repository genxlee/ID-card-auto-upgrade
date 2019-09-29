#
#_SYNOPSIS
#    Open-EID Updater
#_DESCRIPTION
#    Updates installed Open-EID.
#    if Open-EID is missing, then it is installed.
#_NOTES
#    Script name: software-open-eid.ps1
#    Version:     0.1.1
#    Author:      Gen Lee
#    DateCreated: 2018-08-10
#    LastUpdate:  2019-01-19
# 
################################
#      Version History &       #
#        Release Notes         #
################################
# 
#   Version:     0.1
#       - inital creation
#                0.1.1
#       - rewritten to support PS 2.0
#       - script outputs more information

### PARAMETERS & FUNCTIONS ###
function Get-HTTPFile {
    param(
    $url
    ,
    $fileName
    )
    $webClient = New-Object System.Net.WebClient
    $localPath = "$env:temp\$fileName"
    $remote = $url + $fileName
    $ErrorActionPreference = "Stop"
     
    try {
        $webClient.downloadFile($remote,$localPath)
        return $localPath
    } 
    catch [System.Management.Automation.MethodInvocationException] {
        "Error downloading file" | Write-Host
        "Download URL: " + $url | Write-Host
        "Full Error message: " | Write-Host
        $error[0] | Format-List * -f | Write-Host
        return $false
    }
}
### VARIABLES ###
$baseURL = "https://installer.id.ee/media/win/"
$filename = "Open-EID-19.8.0.1844_x86.exe"
$x86_eid = 'C:\Program Files\Open-EID\ID-updater.exe'
$x64_eid = 'C:\Program Files (x86)\Open-EID\ID-updater.exe'
$default_task = "id updater task"
$default_task_exist = schtasks /query /fo LIST | Select-String "$default_task"
### INSTALL OPEN-EID IF MISSING ###
if(!(Test-Path $x86_eid) -and !(Test-Path $x64_eid)) {
    "`r`nOpen-EID is missing, starting download: " + (Get-Date) | Write-Host
    $dlResult = Get-HTTPFile $baseURL $filename
    if ($dlResult -eq $false) {
        "`r`nDownload failed, please install Open-EID manually. Exiting script" | Write-Host
        exit 1
    } else {
        "`r`nDownload successful, starting Open-EID installation: " + (Get-Date) | Write-Host
        & $dlResult /quiet AutoUpdate=0 IconsDesktop=1 RunQesteidutil=0

        $time = 0
        Start-Sleep -Seconds 5

        while (Get-Process | Where-Object {$_.processName -eq ($filename -replace ".exe","")}) {
            Start-Sleep -Seconds 10
            $time++
            if ($time -gt 90) {
                "`r`n$filename has been trying to install for 15 minutes?!? Exiting!" | Write-Host
                (Get-process | Where-Object {$_.processName -eq ($filename -replace ".exe","")}) | Stop-Process -force
                exit 1
            }
        }
        "`r`n$filename Install complete: " + (Get-Date) | Write-Host
    }      
}
### UPDATE OPEN-EID ### 
$installed_eid = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Metapackage"}).Version 
$installed_updater = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Updater"}).Version
if($default_task_exist) {
    schtasks /delete /tn "$default_task" /f
    "`r`nUnregistered default id updater task" | Write-Host
}
if(Test-Path $x86_eid){
    "`r`nBefore update Open-EID version was $installed_eid and Open-EID Updater version was $installed_updater" | Write-Host
    & $x86_eid -autoupdate -autoclose
    "`r`nRan update for x86 Open-EID" | Write-Host
    $installed_eid = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Metapackage"}).Version 
    $installed_updater = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Updater"}).Version
    "`r`nAfter update Open-EID version is $installed_eid and Open-EID Updater version is $installed_updater" | Write-Host
    exit 0
}
if(Test-Path $x64_eid){
    "`r`nBefore update Open-EID version was $installed_eid and Open-EID Updater version was $installed_updater" | Write-Host
    & $x64_eid -autoupdate -autoclose
    "`r`nRan update for x64 Open-EID" | Write-Host
    $installed_eid = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Metapackage"}).Version 
    $installed_updater = (Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Where-Object -FilterScript {$_.Name -like "Open-EID Updater"}).Version
    "`r`nAfter update Open-EID version is $installed_eid and Open-EID Updater version is $installed_updater" | Write-Host
    exit 0
}
