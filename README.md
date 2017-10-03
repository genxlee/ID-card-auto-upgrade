# ID-Card Auto upgrade
Following powershell script adds ID-updater.exe to Task Scheduler so it will keep your Open-EID software up-to-date.

You can run it from elevated CMD:

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/genxlee/IDCard-upgrade/master/idupgrade_taskscheduler.ps1'))"
Written for Estonian ID-Card software (http://id.ee)
