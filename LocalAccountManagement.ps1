<#.SYNOPSIS
Contains functions for performing basic user account management. Each function accepts
pipeline input and can be chained in to the next.

.EXAMPLE
Get-LocalUser
Outputs all local users on local machine (script does not currently handle remote machines)

.EXAMPLE
Get-LocalUser -user Jimbob | Set-LocalUser -ResetPwd Password123!
Resets local user's password to the value assigned to the ResetPwd parameter

.EXAMPLE
Create-LocalUser -username Timothy -password Hello989
Creates local user with specified username and password. If user already exists,
will catch exception error and stop processing.

Remove-LocalUser -username Timothy
Removes specified local user account. If user already exists, will catch exception
error and stop processing.
#>


function Get-LocalUser {
    [CmdletBinding()]
    param (
    [Parameter (
    Mandatory = $False)]

    $User
    )

    $WMILocalUsers = Get-WmiObject -Class win32_account -Filter "LocalAccount='True'"
    if ($User -ne $null) {
        $WMILocalUsers | Where-Object {$_.name -eq $User}
    }
    else {
        $WMILocalUsers
    }
}

function Set-LocalUser{
    [CmdletBinding()]
    param (
    [Parameter(
    Mandatory=$true,
    ValuefromPipelineByPropertyName = $true)]    
    $name,
         
    [switch]$UnlockAccount,
    [string]$ResetPwd,
    [string]$LocalGroup
    )

    if ($UnlockAccount -eq $true) {
        
        $CmdUnlock = cmd /c net user $name /active:Yes

        Invoke-Command -ScriptBlock {$CmdUnlock}
        Write-Verbose "Account Unlocked"
        Write-Debug "User account now set to active (/active:yes)"
    }

    if (($ResetPwd -ne $null) -and ($ResetPwd -ne "")) {
        
        $user = [adsi]"WinNT://localhost/$name"
        $user.SetPassword($ResetPwd)
        $User.SetInfo()
        Write-Verbose "Password has been reset."
    }

    if (($LocalGroup -ne $null) -and ($LocalGroup -ne "")) {

        $CmdAddtoGroup = cmd /c net localgroup $LocalGroup $name /add

        Invoke-Command -ScriptBlock {$CmdAddtoGroup}
    }
}

function Create-LocalUser {
    [CmdletBinding()]
    param (
    [Parameter(
    Mandatory=$true)]
    $username,

    [Parameter(
    Mandatory=$true)]
           
    $password
    )

    $CmdCreateUser = cmd /c net user /add $username $password
    Invoke-Command -ScriptBlock {$CmdCreateUser}
}

function Remove-LocalUser {
    [CmdletBinding()]
    param (
    [Parameter(
    Mandatory=$true)]
    
    $UserName
    )
    
    $CmdRemoveUser = cmd /c net user /delete $UserName
    Invoke-Command -ScriptBlock {$CmdRemoveUser}
}
