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
