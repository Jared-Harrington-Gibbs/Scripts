import-module ExchangeOnlineManagement
Connect-ExchangeOnline

$TargetPolicyState = "Block Basic Auth"
$AuthenticationPolicy = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy

#check if policy is correct and correct if not
If (-not ($AuthenticationPolicy.DefaultAuthenticationPolicy -eq $TargetPolicyState))
{
    try
    {
        $AuthenticationPolicy = Get-AuthenticationPolicy -Identity $TargetPolicyState
        Set-OrganizationConfig -DefaultAuthenticationPolicy $AuthenticationPolicy.Identity
    }
    catch
    {
        
        $AuthenticationPolicy = New-AuthenticationPolicy $TargetPolicyState
        Set-OrganizationConfig -DefaultAuthenticationPolicy $AuthenticationPolicy.Identity
    }
}

$AuthenticationPolicy = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy

#Configure the policy settings
Set-AuthenticationPolicy -Identity $TargetPolicyState `
                         -AllowBasicAuthActiveSync:$false `
                         -AllowBasicAuthAutodiscover:$false `
                         -AllowBasicAuthImap:$false `
                         -AllowBasicAuthMapi:$false `
                         -AllowBasicAuthOfflineAddressBook:$false `
                         -AllowBasicAuthOutlookService:$false `
                         -AllowBasicAuthPop:$false `
                         -AllowBasicAuthPowershell:$false `
                         -AllowBasicAuthReportingWebServices:$false `
                         -AllowBasicAuthRest:$false `
                         -AllowBasicAuthRpc:$false `
                         -AllowBasicAuthSmtp:$false `
                         -AllowBasicAuthWebServices:$false

$UserList = Get-User -ResultSize Unlimited

#set all users to use the default policy
$itemNumber=1
foreach ($user in $UserList)
{
    try
    {
        Write-Progress -Activity "Updating $($user.Identity)" `
                       -Status "User $($itemnumber) of $($UserList.count)" `
                       -PercentComplete (($itemnumber*100)/$UserList.Count)
        
        $itemNumber++

        Set-User -Identity $user.Identity -AuthenticationPolicy $AuthenticationPolicy.DefaultAuthenticationPolicy -STSRefreshTokensValidFrom $([System.DateTime]::UtcNow) 
        
    }
    catch
    {
        Write-Warning $_.Exception.Message
    }
}

#check results
$OrgConfig = Get-OrganizationConfig | Select-Object -ExpandProperty DefaultAuthenticationPolicy | ForEach { Get-AuthenticationPolicy $_ | Select-Object AllowBasicAuth* }

$UserList = Get-User -ResultSize Unlimited
$UnmodifiedUsers = $UserList | Where-Object {$_.AuthenticationPolicy -ne $TargetPolicyState}| Select-Object UserPrincipalName, AuthenticationPolicy

Write-Output "Default Policy Settings"
Write-Output "======================="
Write-Output $OrgConfig


Write-Output "You still need to set the policy on these users."
Write-Output "================================================"
Write-Output $UnmodifiedUsers
