# These can be changed to whatever we want"
$password = 'HelloMyNameIsAdmin!!'
$new_name = 'not_adminHEHE'

If (-NOT ([String]$PWD -eq 'C:\Windows\system32')){
    'Please run PS as admin to run this script'
}

Else 
    {
    #Query local admin user
    $admin_user = Get-LocalUser -Name "Administrator"
    # If there is not a local user named Administrator
    If (!$admin_user){
        'Is the admin account named something different? Here is the local admin group:'
        # Query local admin group
        net localgroup 'Administrators'
        # Get-LocalGroupMember "Administrators"
        # What group 
        $new_user = Read-Host -Prompt 'What user is the admin user?'
        net user $new_user $password
        'password changed'
        $yesnoresponse = Read-Host -Prompt 'Would you like to rename this account?(y/n)'
        If ($yesnoresponse -eq 'y'){
            Rename-LocalUser -Name $new_user -NewName $new_name
            'Account renamed'
        }
    }

    # If there is a user named Administrator
    Else {
        net user $admin_user $password
        'password changed'
        Rename-LocalUser -Name $admin_user -NewName 'not_adminHEHE'
        'account renamed to' + $new_name
    }
}
