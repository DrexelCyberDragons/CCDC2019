# Blue Team Windows Scripts

This repo is meant to be a master collection of scripts that can be used to easily secure a minimally install/configured domain.  

At its core, it consists of a script to be run against a domain controller, a script to run against a domain member, and a number of domain policy that will be imported.

An outline of the DC script:
1. Build out a new user structure (hostname + u for standard, and hostname + uadm for admin users).  The premise behind this is that each computer on the domain besides the domain controller will have a standard user that is used to login with and perform non-administrative actions.  Each time you want to elevate, the admin user for that machine.  This is in an attempt to cut down lateral movement.  The caveat and downside with this is if the environment scales to more than 20 machines, password management becomes very hard.  
This is not meant to scale!!!! Please only use in a small environment.
2. Deploy a security policy and audit policy that is relatively strict and allows for extensive logging.
3. Pull various installers from the web (winlogbeat, malwarebytes, and a number of the sysinternals tools)
4. Push a smaller, domaim member script along with installers to each domain machine found.  If this doesn't happen, the code to pull the folder from a domain member will be as such 
```
$path = "C:\Windows\System32\dm\dm_script.ps1"
if([System.IO.File]::Exists($path)){
	cd C:\Windows\System32\dm
	./dm_script.ps1
}else{
	xcopy \\host_with_ad_script\c$\Windows\System32\run\dm dm /e /i /y /s
}
```
5. Test remote WMI ports, and if available, run setup on remote host from a user perspective.
6. Enable WinRM/ps-remoting
7. Disable NetBIOS on a host
8. Install sysmon w/ a pre-build config
9. Configure OU structure to facilitate easier management
10. Deploy blue-team persistent mechanisms.  For example, when sysmon is killed, stopped, or removed, a permanent wmi subscription will run a powershell script to fully reinstall sysmon.  This is in place to restart the windows firewall, termservices(RDP), and winlogbeat as well.

Steps to run:
1. drop the entire "run" directory on a domain controller into the C:\Windows\System32
2. Unpack archive
3. Browse to C:\Windows\System32 and run ad_script.ps1
4. This will deploy everything.  You will be required to enter a few passwords along the way
5. On each domain member, run the above code block.
6. Enter the new local admin password
7. Enjoy!

There may be extended steps along the way, and this script is a very large work in progress.  There may also be functionality that will just simply not work with PowerShell 2.0 and below, however I've written it to be easy to troubleshoot and change.
