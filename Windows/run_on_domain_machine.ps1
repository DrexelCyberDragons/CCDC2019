<#Collective CCDC Script for any domain machine
TODO (member and management machine): 
1. put y/n checks in front of each option, we want to be able to restart the box and not have to go through each step again
X 2. ask for full path to kb patch for winrm3.0
X 3. ask for full path to .net4.0 installer (Maybe setup a script to create a readable share on whatever management machine there is)
X 4. disable netbios
X 5. change guest name/password as well
X 6. Add standard user accounts to local remote desktop users group
7. setup install for sysmon
X . ask if the computer is management machine and do install of roles if so
X 9. at end, run key manager and delete all entries listed
10. if management machine create a file share readable to all users, but not editable unless Admin role

ToDo (Domain Controller):
X 1. Change built in admin username and password
X 2. Change guest acct name/password
3. Change krbtgt pass?
4. create and import GPO settings
X 5. add to main script
6. change all domain admin acct passwords
X 7. create standard user account for everyone
8. make a failsafe account?
#>

# Declare variables
$winrmversion = $PSVersionTable.WSManStackVersion.Major
$password = 'HelloMyNameIsAdmin!!'
$new_name = 'not_adminHEHE'
$new_guestuser = 'HarryTheDwarf'
$domainname = [string](Get-WmiObject Win32_ComputerSystem).Domain
$machinename = [string](Get-WmiObject Win32_ComputerSystem).Name

$rfiers = $domainname + '\rfiers'
$dkelly = $domainname + '\dkelly'
$jyoo = $domainname + '\jyoo'

Write-Host -ForegroundColor Yellow '[=]Please give the full filepath to the backups and patches folder(e.g. c:\Users\rfiers\Desktop\CCDC'
$filepath = Read-Host

# Pull updated GPO
function updateGPO{
  
    Write-Host -ForeGroundColor Green '[+]Pulling and updating GPO'
    gpupdate /force

}

# Change local admin user name + password
# Added: change local guest account name + pass
function localAdminChange{
    #Query local admin user
    $admin_user = Get-LocalUser -Name "Administrator"
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
            Rename-LocalUser -Name $new_user -NewName $new_name
            Write-Host -ForgroundColor Green '[+]Account Successfully renamed to ' + $new_name + '!'
        }
    }

    # If there is a user named Administrator
    Else {
        net user $admin_user $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        Rename-LocalUser -Name $admin_user -NewName 'not_adminHEHE' 
        Write-Host -ForegroundColor Green '[+]Account successfully renamed to ' + $new_name + '!'
    }

    # Change local guest username and password
    $guest_user = GetLocalUser -Name 'Guest'
    If (!$guest_user){
        Write-Host -ForegroundColor Yellow '[=]Is the guest account named something different?Here are all local users: '
        Get-LocalUser
        Write-Host -ForegroundColor Yellow '[=]what user is the guest user?'
        $newguest = Read-Host
        net user $newguest $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        Write-Host -ForegroundColor Yellow '[=]Would you like to rename this account?(y/n)'
        $yesnoresponse2 = Read-Host
        If ($yesnoresponse2 -eq 'y'){
            Rename-LocalUser -Name $newguest -NewName $new_guestname
            Write-Host -ForgroundColor Green '[+]Account Successfully renamed to ' + $new_guestname + '!'
        }
    }
    Else {
        net user $guest_user $password
        Write-Host -ForegroundColor Green '[+]Password successfully changed!'
        Rename-LocalUser -Name $guest_user -NewName $new_guestuser
        Write-Host -ForegroundColor Green '[+]Account successfully renamed to ' + $new_guest + '!'
    
}

# WinRM setup MUST FINISH
function winrmsetup{

    # winrm / remote management steps
    If ([int]$winrmversion -eq 2){
        # begin installation steps
        write-host -ForegroundColor Red '[-]winrm version 2 detected, beginning installation steps'
        # .net4.0 install
        $dotnetfilepath = $filepath + '\dotNetFx40_Full_setup.exe'
        Start-Process $dotnetfilepath -Wait
        Write-Host -ForegroundColor Green '[+]dotNet4.0 installed'
        # patch install
        $arglist1 = '/I ' + $filepath
        Start-Process msiexec.exe -Wait -ArgumentList  $arglist1
        Write-Host -ForegroundColor Green '[+]Patch installed'
    } ElseIf ([int]$winrmversion -eq 3){
        # run quickconfig, this requires input and enable psremoting
        winrm quickconfig
        Enable-PSRemoting
    }
    Write-Host -ForegroundColor Yellow '[=]What is the IP of the remote box you want added to trusted host?(can probably add multiples comma separated)'
    $compname = Read-Host
    # Clear trusted Hosts first
    Clear-Item -Path WSMan:\localhost\Client\TrustedHosts -Force
    # add computer(should be the jumpbox that colbert needs to use) to trusted host
    # winrm s winrm/config/client '@{TrustedHosts=$compname'
    Set-Item WSMan:\localhost\Client\TrustedHosts $compname
    write-host -ForegroundColor Green '[+]Machine(s) added to TrustedHosts: ' + $compname
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
    Write-Host -ForegroundColor Yellow '[=]Would you like to disable Netbios across all interfaces?(If already disabled, ignore.  Be Careful, may break functionality)(y/n)'
    $yesorno = Read-Host
    If ($yesorno -eq 'y'){
           Get-ChildItem $key | foreach { Set-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}
           Write-Host -ForegroundColor Green '[+]Netbios Disabled'
    }
}

# Allow local accounts to remote
function localcreate{

    net user rfiers /add /domain
    net user dkelly /add /domain
    net user jyoo /add /domain
    Write-Host -ForegroundColor Green '[+]Standard users successfully created'
    net group "Domain Users" $rfiers,$dkelly,$jyoo /add /domain
    net group "Remote Desktop Users" $rfiers,$dkelly,$jyoo /add /domain
    Write-Host -ForegroundColor Green '[+]Users added to domain groups, Domain Users and Remote Desktop Users'
}

# Add standard users to local remote desktop users group
function localadd{
    
    net localgroup 'Remote Desktop Users' $rfiers,$dkelly,$jyoo /add
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
    
    # create blank GPO's, make DA's the only ones able to edit
    # import-gpo -BackupGpoName TestGPO -TargetName TestGPO -path c:\backups 
    #ooorrrrrr :::: import-gpo -BackupId A491D730-F3ED-464C-B8C9-F50562C536AA -TargetName TestGPO -path c:\backups -CreateIfNeeded 
    # This will actually create a gpo if none exist, so we wont have to pipe in a blank GPO

}

# Create additional AD OU's for each server version
function AD_shimmy{
    
    # create 2003_servers, 2008_servers, 2012_servers, 2016_servers, 2019_servers and manually add computers to each
    # we can grab the distinguished name from something like this: (Get-ADUser username).DistinguishedName
    New-ADOrganizationalUnit -Name "2012_servers" -Path "DC=BLAH,DC=COM"
    New-ADOrganizationalUnit -Name "2008_servers" -Path "DC=BLAH,DC=COM"
    New-ADOrganizationalUnit -Name "2003_servers" -Path "DC=BLAH,DC=COM"
    New-ADOrganizationalUnit -Name "2016_servers" -Path "DC=BLAH,DC=COM"
    New-ADOrganizationalUnit -Name "2019_servers" -Path "DC=BLAH,DC=COM"
    Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
}


# run key manager and delete all entries
function key_manager{

    rundll32.exe keymgr.dll, KRShowKeyMgr
}

# Change krbtgt acct pass
function krbtgt_change{

    
}

# Change builtin admin pass and user
function builtinadm_change{
    
    # get-adobject -identity "CN=Administrator,CN=Users,DC=lab,DC=test" | rename-adobject -newname "builtin_adm"
    # Set-ADAccountPassword -Identity builtin_adm -NewPassword (ConvertTo-SecureString -AsPlainText "!__@bsurd3lyL0ngP@ssw0rd__!" -Force)
}

# install sysmon and run autoruns

function sysmon{
    
    # silent install sysmon (add config if necessary)
    ./Sysmon64.exe -i -n -accepteula
    # staetup autoruns to begin diagnosing and stopping unnecessary services/autosets
    ./Autoruns64.exe
}

# baseline
function baseline{

    # run netstat, firewall show, ipconfig, print to file, and store file
    $filename = $machinename + '_baseline.txt'
    echo "-----Begin baseline for $machinename-----" > $filename
    echo "Run ipconfig:" >> $filename
    ipconfig /all >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run netstat -nao:" >> $filename
    netstat -nao >> $filename
    echo "-----------------------------------" >> $filename
    echo "Run netstat -abn:" >> $filename
    netstat -abn >> $filename
    
}


# Check if running as Administrator
If (-NOT ([String]$PWD -eq 'C:\Windows\system32')){
    Write-Host -ForegroundColor Red '[-]Restarting PS as an admin, hang tight..... Enter credentials when prompted and restart the script'
    Start-process powershell -verb runas
    break
}

# If we are already running in Admin context(wont work if this path is changed)
Else 
    {
    # ASk whether DC, Domain Member, or Management machine
    Write-Host 'Is this machine a dc, dm, or m (domain controller, domain member, management)?'
    $compchoice = Read-Host
    If ($compchoice -eq 'dc'){
        # DC centric tasks
        Write-Host -ForegroundColor Cyan '[=]You have selected a domain controller, if this is not correct exit the script.'
        Start-Sleep -s 5


    }ElseIf($compchoice -eq 'dm'){
        # Domain Member centric tasks
        Write-Host -ForegroundColor Cyan '[=]You have selected a domain member, if this is not correct exit the script.'
        Start-Sleep -s 5

    }ElseIf($compchoice -eq 'm'){
        # Management machine centric tasks
        Write-Host -ForegroundColor Cyan '[=]You have selected a management machine, if this is not correct exit the script.'
        Start-Sleep -s 5

    }Else{

        # Anything else is not a valid option so exit
        Write-Host -ForegroundColor Red '[-]Not a valid choice, exiting'
        break
    }

}

