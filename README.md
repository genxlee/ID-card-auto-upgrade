# ID-Card Auto upgrade
Following powershell script adds ID-updater.exe to Task Scheduler so it will be run silently at system start-up.

You can run it from elevated CMD:

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/genxlee/IDCard-upgrade/idupgrade_taskscheduler.ps1'))"
Written for Estonian ID-Card software (http://id.ee)
