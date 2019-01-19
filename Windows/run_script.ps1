<#Collective CCDC Script for any domain machine
TODO (member and management machine): 
1. put y/n checks in front of each option, we want to be able to restart the box and not have to go through each step again
X 2. ask for full path to kb patch for winrm3.0
X 3. ask for full path to .net4.0 installer (Maybe setup a script to create a readable share on whatever management machine there is)
X 4. disable netbios
X 5. change guest name/password as well
X 6. Add standard user accounts to local remote desktop users group
X 7. setup install for sysmon
X . ask if the computer is management machine and do install of roles if so
X 9. at end, run key manager and delete all entries listed
XXXXXXXX10. if management machine create a file share readable to all users, but not editable unless Admin role

ToDo (Domain Controller):
X 1. Change built in admin username and password
X 2. Change guest acct name/password
3. Change krbtgt pass?
4. create and import GPO settings
X 5. add to main script
6. change all domain admin acct passwords, iterate through DA group
7. Create new DA accounts for everyone, 5 accts
X 7. create standard user account for everyone
XXXXXXXX 8. make a failsafe account?

Both Types:
1. Admin settings
2. block ip by firewall, enable firewall rule
3. Query process tree and query information about a process, netstat, process query, tasklist /v, TASKLIST /FI "imagename eq svchost.exe" /svc
4. edit modsec settings? <----How
5. auditpol /get /Category:*
6. Query certain registry keys, such as runonce, etc
#>

# Declare variables
$winrmversion = $PSVersionTable.WSManStackVersion.Major

$new_name = 'not_adminHEHE'
$new_guestuser = 'HarryTheDwarf'

# ask for passwords
$password = 'HelloMyNameIsAdmin!!'
# $builtin_pass = '!__@bsurd3lyL0ngP@ssw0rd__!'

$domainname = [string](Get-WmiObject Win32_ComputerSystem).Domain
$machinename = [string](Get-WmiObject Win32_ComputerSystem).Name
# $ips = (get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}).IPAddress
$ips = (get-WmiObject Win32_NetworkAdapterConfiguration)
$dist_name = ''

$rfiers = $domainname + '\rfiers'
$dkelly = $domainname + '\dkelly'
$jyoo = $domainname + '\jyoo'
$czhu = $domainname + '\czhu'
$nickd = $domainname + '\nickd'

$dir_letter = ([string]$PWD)[0]
$path1 = "$dir_letter" +  ':\Users'
$full_path = [string](Get-ChildItem -Path $path1 -Recurse -ErrorAction SilentlyContinue -Include run_script.ps1)
$work_dir = ([string]$full_path).replace("run_script.ps1","")

#Write-Host -ForegroundColor Yellow '[=]Please give the full filepath to the backups and patches folder(e.g. c:\Users\rfiers\Desktop\CCDC'
#$filepath = Read-Host

# Pull updated GPO
function updateGPO{
    
    Write-Host -ForeGroundColor Green '[+]Pulling and updating GPO'
    gpupdate /force

}

# Change local admin user name + password
# Added: change local guest account name + pass
function localAdminChange{

    #Query local admin user
    #$admin_user = Get-LocalUser -Name "Administrator"
    $admin_iser = net user 'Administrator'
    # If there is no local user named Administrator
    If (!$admin_user){
        Write-Host -ForegroundColor Yellow '[=]Is the admin account named something different? Here is the local admin group:'
        # Query local admin group
        net localgroup 'Administrators'
        # Get-LocalGroupMember "Administrators"
        # What group 
        Write-Host -ForegroundColor Yellow '[=]What user is the admin user?'
        $new_user = Read-Host
        net user $new_user $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        Write-Host -ForegroundColor Yellow '[=]Would you like to rename this account?(y/n)'
        $yesnoresponse = Read-Host
        If ($yesnoresponse -eq 'y'){
            # Rename-LocalUser -Name $new_user -NewName $new_name
            wmic useraccount where fullname=$newuser rename $new_name
            Write-Host -ForgroundColor Green "[+]Account Successfully renamed to $new_name !"
        }
    }

    # If there is a user named Administrator
    Else {
        net user $admin_user $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        # Rename-LocalUser -Name $admin_user -NewName $new_name 
        wmic useraccount where fullname=$admin_user rename $new_name
        Write-Host -ForegroundColor Green "[+]Account successfully renamed to $new_name !"
    }

    # Change local guest username and password
    # GPO will disable
    # $guest_user = GetLocalUser -Name 'Guest'
    $guest_user = net user Guest
    If (!$guest_user){
        Write-Host -ForegroundColor Yellow '[=]Is the guest account named something different?Here are all local users: '
        # Get-LocalUser
        net user
        Write-Host -ForegroundColor Yellow '[=]what user is the guest user?'
        $newguest = Read-Host
        net user $newguest $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        Write-Host -ForegroundColor Yellow '[=]Would you like to rename this account?(y/n)'
        $yesnoresponse2 = Read-Host
        If ($yesnoresponse2 -eq 'y'){
            # Rename-LocalUser -Name $newguest -NewName $new_guestname
            wmic useraccount where fullname=$newguest rename $new_guestname
            Write-Host -ForgroundColor Green '[+]Account Successfully renamed to ' + $new_guestname + '!'
        }
    }
    Else {
        net user $guest_user $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        # Rename-LocalUser -Name $guest_user -NewName $new_guestuser
        wmic useraccount where fullname=$guest_user rename $new_guestuser
        Write-Host -ForegroundColor Green '[+]Account successfully renamed to ' + $new_guest + '!'
    }
    
}

# WinRM setup MUST FINISH
# TODO, 
function winrmsetup{

    # ENABLE RPC FIREWALL PORTS
    # winrm / remote management steps
    Write-Host -ForegroundColor Yellow "[=]Checking WinRM Stack Version `n"
    Write-Host -ForegroundColor Yellow "[=]Seems to be version $winrmversion"
    If ([int]$winrmversion -eq 2){
        # begin installation steps
        write-host -ForegroundColor Red '[-]winrm version 2 detected, beginning installation steps'
        # .net4.0 install
        $dotnetfilepath = $work_dir + "\dotNetFx40_Full_setup.exe"
        Start-Process $dotnetfilepath -Wait
	    #./dotnetfilepath
        Write-Host -ForegroundColor Green '[+]dotNet4.0 installed'
        # patch install
        # $arglist1 = "/I $work_dir\Windows6.1-KB2506143-x64.msi"
	    $patchpath = $work_dir + "\Windows6.1-KB2506143-x64.msu"
	    Start-Process $patchpath -Wait
        # Start-Process msiexec.exe -Wait -ArgumentList  $arglist1
        Write-Host -ForegroundColor Green '[+]Patch installed'
    } ElseIf ([int]$winrmversion -eq 3){
        # run quickconfig, this requires input and enable psremoting
        # SET RPC PORTS OPEN ON ALL PROFILES
        #should enable firewall rule to allow RPC service to talk
        Write-Host "Enable firewall RPC ports through firewall"
        netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes
        winrm quickconfig
        Enable-PSRemoting
    }
    #Write-Host -ForegroundColor Yellow '[=]What is the IP of the remote box you want added to trusted host?(can probably add multiples comma separated)'
    #$compname = Read-Host
    # Clear trusted Hosts first
    #Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
    # add computer(should be the jumpbox that colbert needs to use) to trusted host
    # winrm s winrm/config/client '@{TrustedHosts=$compname'
    #Set-Item WSMan:\localhost\Client\TrustedHosts $compname
 
    Write-Host -ForegroundColor Yellow "[=]Which of the following IP's is the correct IP?"
    $ip = Read-Host
    $ips
    write-host -ForegroundColor Yellow '[=]Please go to machine you want to manage from(off domain) and run the following commands and edit GPO to only accept connections from your remote machine, rather than *'
    write-host -ForegroundColor Yellow '[=]If you are managing fom a domain joined machine, do not run the above commands, instead edit GPO and remove Trusted Hosts from Policies/Admin Templates/ Windows Components/Windows Remote management'
    write-host -ForegroundColor Yellow '                   1.     Clear-item -Path WSMan:\localhost\Client\TrustedHosts -Force'
    write-host -ForegroundColor Yellow "                   2.     " 'Set-item WSMan:\localhost\Client\TrustedHosts ' + "$ip"
}

# Disable NetBIOS on all adapters
function netbios_disable{
    
    # Query for Netbios Registry Key and disable if necessary
    # 0 is enable NetBios from DHCP Server
    # 1 is enable NetBios over TCP/IP
    # 2 is disabled
    Write-host 'Netbios Registry Keys:'
    $key = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" 
    Get-ChildItem $key | foreach {$val = Get-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions; If ([int]$val.NetbiosOptions -eq 2){ Write-Host -ForegroundColor Green 'Adapter' $_.pschildname 'has NetBios Disabled!'}ElseIf([int]$val.NetbiosOptions -ne 2){Write-Host -ForegroundColor Red 'Adapter' + $_.pschildname + 'has NetBios Enabled!'}}
    Write-Host -ForegroundColor Yellow '[=]Would you like to disable Netbios across all interfaces?(If already disabled, ignore.  Be Careful, may break functionality for legacy systems)(y/n)'
    $yesorno = Read-Host
    If ($yesorno -eq 'y'){
           Get-ChildItem $key | foreach { Set-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}
           Write-Host -ForegroundColor Green '[+]Netbios Disabled'
    }
}

# Allow standard accounts to remote
function stdcreate{

    # These are in cleartext, be careful powershell is not logging script blocks or else these will be captured
    net user rfiers !!_Big_Long_Password_!! /add /domain
    net user dkelly !!_Big_Long_Password_!! /add /domain
    net user jyoo !!_Big_Long_Password_!! /add /domain
    net user czhu !!_Big_Long_Password_!! /add /domain
    net user nickd !!_Big_Long_Password_!! /add /domain
    Write-Host -ForegroundColor Green '[+]Standard users successfully created'
    net group "Domain Users" $rfiers,$dkelly,$jyoo,$czhu,$nickd /add /domain
    #                  |||
    # Check this group vvv this may be something that has to be done 
    # net group "Remote Desktop Users" $rfiers,$dkelly,$jyoo,$czhu,$nickd /add /domain
    Add-ADGroupMember -Identity "Remote Desktop Users" -Members rfiers,dkelly,jyoo,czhu,nickd
    Write-Host -ForegroundColor Green '[+]Users added to domain groups, Domain Users and Remote Desktop Users'
}

# Add standard users to local remote desktop users group on each domain computer
function stdadd{
    
    net localgroup 'Remote Desktop Users' $rfiers,$dkelly,$jyoo,$czhu,$nickd /add
    net localgroup 'Remote Desktop Users'
    Write-Host -ForegroundColor Green '[+]Users successfully written to local Remote Desktop Users group'
}

# Install management roles on management machine
function management_roles{

    # all roles necessary to manage the environment minus the SQL tool
    Install-WindowsFeature Remote-Desktop-Services,GPMC,Web-Mgmt-Console,RSAT-Role-Tools,RSAT-AD-PowerShell,RSAT-DHCP,RSAT-DNS-Server -IncludeManagementTools

}

# GPO creation and import, make sure backups are located in the run folder
function gpoimport{

    # Hopefully this module installs, but should be if DC
    # Import-Module GroupPolicy
    
    # create blank GPO's, make DA's the only ones able to edit
    # import-gpo -BackupGpoName TestGPO -TargetName TestGPO -path c:\backups 
    #ooorrrrrr :::: import-gpo -BackupId A491D730-F3ED-464C-B8C9-F50562C536AA -TargetName TestGPO -path c:\backups -CreateIfNeeded 
    # This will actually create a gpo if none exist, so we wont have to pipe in a blank GPO

    import-gpo -BackupGpoName 2012_Member_Security -TargetName 2012_member_Security -path $work_dir -CreateIfNeeded
    import-gpo -BackupGpoName Domain_overall -TargetName Domain_overall -path $work_dir -CreateIfNeeded
    import-gpo -BackupGpoName Domain_Member_Audit -TargetName Domain_member_Audit -path $work_dir -CreateIfNeeded
    import-gpo -BackupGpoName DC_Security -TargetName 2012_DC_Security -path $work_dir -CreateIfNeeded
    import-gpo -BackupGpoName DC_Audit -TargetName DC_Audit -path $work_dir -CreateIfNeeded
    #pull the backup into runscript
    import-gpo -BackupGpoName Firewall_Policy -TargetName Firewall_Policy -path $work_dir -CreateIfNeeded

}

# Create additional AD OU's for each server version
function AD_shimmy{
    
    # create 2003_servers, 2008_servers, 2012_servers, 2016_servers, 2019_servers and manually add computers to each
    # we can grab the distinguished name from something like this: (Get-ADUser username).DistinguishedName
    $usr_dc = ((Get-ADUser $rfiers).DistinguishedName.Split(","))
    # format the correct distinguished name 
    $dist_name = $usr_dc[$usr_dc.length - 2] + "," + $usr_dc[$usr_dc.length - 1]
    New-ADOrganizationalUnit -Name "Servers" -Path "$dist_name"
    #New-ADOrganizationalUnit -Name "2012_servers" -Path "$dist_name"
    #New-ADOrganizationalUnit -Name "2008_servers" -Path "$dist_name"
    #New-ADOrganizationalUnit -Name "2003_servers" -Path "$dist_name"
    #New-ADOrganizationalUnit -Name "2016_servers" -Path "$dist_name"
    #New-ADOrganizationalUnit -Name "2019_servers" -Path "OU=2012_servers,$dist_name"
    # Display OU's
    Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
}


# run key manager for user to manually delete entries
function key_manager{

    rundll32.exe keymgr.dll, KRShowKeyMgr
}

<# Change krbtgt acct pass
function krbtgt_change{

    
}
#>
# Change builtin admin pass and user
function builtinadm_change{

    # This requires the AD Powershell module
    # grab the built in administrator of User
    # get-adobject -identity "CN=Administrator,CN=Users,$dist_name" | rename-adobject -newname "builtin_adm"
    # Set-ADAccountPassword -Identity builtin_adm -NewPassword (ConvertTo-SecureString -AsPlainText "!__@bsurd3lyL0ngP@ssw0rd__!" -Force)
    # net user 'Administrator' /domain

    $builtin = net user Administrator /domain
    If (!$builtin){
        Write-Host -ForegroundColor Yellow "[=]Is the Builtin Admin account named something different?Here are all Administrator users of the domain: `n"
        # Get-LocalUser
        Write-Host "Enterprise Admins Group"
        net group 'Enterprise Admins' /domain
        Write-Host "Administrators group of the domain, if you see a user here query for them seperately to determine. `n"
        #Read-Host -Prompt "Press any key to continue"
        net group 'Administrators' /domain
        Write-Host -ForegroundColor Yellow "[=]What user is the builtin admin?"
        $newbuiltin = Read-Host
        Write-Host -ForegroundColor Yellow '[=]What will the password for this account be?'
        $builtin_pass = Read-Host -AsSecureString
        # Write-Host -ForegoundColor Green "The password you have entered is: $builtin_pass : please make note of it.  This cannot be changed midscript `n"
        Read-Host -Prompt "Press any key to continue" 
        net user $newbuiltin $builtin_pass /domain
        Write-Host -ForegroundColor Green "[+]Password successfully changed! `n"
        Write-Host -ForegroundColor Yellow "[=]Would you like to rename this account?(y/n)"
        $yesnoresponse2 = Read-Host
        If ($yesnoresponse2 -eq 'y'){
            # Rename-LocalUser -Name $newguest -NewName $new_guestname
            # wmic useraccount where fullname=$newguest rename $new_guestname
            get-adobject -identity "CN=$newbuiltin,CN=Users,$dist_name" | rename-adobject -newname "builtin_adm"
            Write-Host -ForgroundColor Green '[+]Account Successfully renamed to builtin_adm!'
        }
    }
    Else {
        net user $newbuiltin $builtin_pass /domain
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        # Rename-LocalUser -Name $guest_user -NewName $new_guestuser
        # wmic useraccount where fullname=$guest_user rename $new_guestuser
        get-adobject -identity "CN=Administrator,CN=Users,$dist_name" | rename-adobject -newname "builtin_adm"
        Write-Host -ForegroundColor Green '[+]Account Successfully renamed to builtin_adm!'
    }
}

# install sysmon and run autoruns

function sysmon{
    
    # silent install sysmon (add config if necessary)
    ./Sysmon64.exe -i config.xml -n -accepteula
    # startup autoruns to begin diagnosing and stopping unnecessary services/autosets
    #./Autoruns64.exe
}

# baseline
# Dont necessarily need this because OSSEC will take care of this
function baseline{

    # run netstat, firewall show, ipconfig, print to file, and store file
    $filename = "c:\$machinename" + '_baseline.txt'
    echo "-----Begin baseline for $machinename-----" > $filename
    echo "Run ipconfig:" >> $filename
    ipconfig /all >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run netstat -nao:" >> $filename
    netstat -nao >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run netstat -abn:" >> $filename
    netstat -abn >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run Get Logged on User" >> $filename
    gwmi Win32_LoggedOnUser | Select Antecedent >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run Query User" >> $filename
    query user >> $filename
    echo "-----------------------------------" >> $filename
    # add firewall rule dump

}

# enable firewall logging for different profiles
function firewall_log{

    # domain firewall logging
    Set-NetFirewallProfile -name domain -LogMaxSizeKilobytes 10240 -LogAllowed true -LogBlocked true
    # %systemroot%\system32\LogFiles\Firewall\pfirewall.log      <--- log path
}

# Create a bunch of new DA users for IR to use
function DA_create{

    # create 2 DA users
    Write-Host "Enter a password for user: czhu_adm `n"
    $czhu_pass = Read-Host -AsSecureString
    New-ADUser -Name "czhu_adm" -AccountPassword $czhu_pass -Enabled $True
    Write-Host "Enter a password for user: nickd_adm `n"
    $nickd_pass = Read-Host -AsSecureString
    New-ADUser -Name "nickd_adm" -AccountPassword $nickd_pass -Enabled $True
    Add-ADGroupMember -Identity "Domain Admins" -Members nickd_adm,czhu_adm
    
}

<#function rpc_enable{

    #should enable firewall rule to allow RPC service to talk
    Write-Host "Enable firewall RPC ports through firewall"
    netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes
}#>

# run installer for logbeat in the meantime
function logbeat_install{
    
    .\winlogbeat\install-service-winlogbeat.ps1
}

function exec_policy{
    # allow scripts to run unrestrained, this may or may not be a bad thing
    Write-Host -ForegroundColor Red "[!]The execution policy on scripts is about to be changed to unrestricted, do you want to proceed?(y/n)"
    $answer = Read-Host
    If ($answer -eq 'y'){
        set-executionpolicy unrestricted
        Write-Host -ForegroundColor Red "[!]Execution policy changed!"
    }
    Else{
        Write-Host -ForegroundColor Red "[!]Execution policy NOT changed"
    }
}

try {
    # Writing to the c home directory should be an admin function??
    echo '' > c:/admin_test.txt
    rm c:/admin_test.txt
    #Begin to ask if DC, DM, or Management machine
    Write-Host "Is this machine a 1. Domain Controller, 2. Domain Member, or 3. Management Machine?"
    $machinechoice = Read-Host
    If ($machinechoice -eq 1){
        # Domain controller specific tasks
        #Write-Host "$machinename"
        Write-Host -ForegroundColor Cyan '[=]You have selected a domain controller, if this is not correct exit the script.'
        Start-Sleep -s 5
        Netsh advfirewall set currentprofile state on
        Start-Sleep -s 5
        baseline
        Start-Sleep -s 5
        builtinadm_change
        Start-Sleep -s 5
        

    }ElseIf($machinechoice -eq 2){
        # Domain Member specific tasks
        Write-Host -ForegroundColor Cyan '[=]You have selected a domain member, if this is not correct exit the script.'
        Start-Sleep -s 5


    }ElseIf($machinechoice -eq 3){
        # Management machine specific tasks
        Write-Host -ForegroundColor Cyan '[=]You have selected a management machine, if this is not correct exit the script.'
        Start-Sleep -s 5


    }

}catch{
    Write-Host -ForegroundColor Red '[-]Access Denied, restarting as admin, enter credentials if/when prompted'
    $path = "& '$full_path" + "'"
    Start-Process powershell $path -verb runas -Wait; exit
   
}