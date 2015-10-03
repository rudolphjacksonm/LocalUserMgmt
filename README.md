
    .SYNOPSIS
    Contains functions for performing basic user account management

    .EXAMPLE
    Get-LocalUser
    Outputs all local users on local machine

    Get-LocalUser -user Jimbob | Set-LocalUser -ResetPwd Password123!
    Resets local user's password to the value assigned to the ResetPwd parameter
    
    Get-LocalUser -user Jimbob | Set-LocalUser -LocalGroup administrators
    Adds user 'jimbob' to the local administrators group
    
    Get-LocalUser -user Jimbob | Set-LocalUser -UnlockAccount
    Unlocks user 'jimbob' account

    Create-LocalUser -username Timothy -password Hello989
    Creates local user with specified username and password. If user already exists,
    will catch exception error and stop processing.

    Remove-LocalUser -username Timothy
    Removes specified local user account. If user already exists, will catch exception
    error and stop processing.
