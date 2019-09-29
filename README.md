# Open-EID Auto upgrade

## idupgrade_taskscheduler.ps1
Adds Task Scheduler task running ID-updater.exe with silent switches keeping Open-EID software at every boot up-to-date.

## software_open-eid.ps1
Updates installed Open-EID, if Open-EID is missing, then it is installed. Useful to make sure that system always has Open-EID installed with latest updates. This script should be executed periodically.. for example with PDQ, Ansible or Windows Task Scheduler.
