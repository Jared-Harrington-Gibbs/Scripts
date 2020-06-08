#get tenant info
$allUsersList=Get-AzureADUser -All $true
$licensePlanList = Get-AzureADSubscribedSku

#get unlicensed users
$unlicensedUsers = $allUsersList | ForEach{ 
    $licensed=$False

    For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) 
    {
        If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].SkuId ) -ne $True) { $licensed=$true } 
    }
    
    If( $licensed -eq $false) 
    {
        return $_
    }
}

#get licensed users
$licensedUsers = $allUsersList | 
    ForEach{ 
        $licensed=$False

        For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) 
        {
            If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].SkuId ) -ne $True) { $licensed=$true } 
        }
        
        If( $licensed -eq $true) 
        {
            return $_
        }
    }

#set calculated properties. For more info see: https://mcpmag.com/articles/2017/01/19/using-powershell-calculated-properties.aspx
$ServicePackageName = @{name="ServicePackageName";e={$_.SkuPartNumber}}
$ServiceCount = @{name="ServiceCount";e={($_.serviceplans).count}}
$ServiceNames = @{name="ServiceNames";e={$_.serviceplans.ServicePlanName}}

#write skus and their included plans
$licensePlanList|select $ServicePackageName,$ServiceNames,$ServiceCount|fl

#example of filtering for specific skus
$licenses = $licensePlanList |where {$_.skupartnumber -eq "EMS" -or $_.skupartnumber -eq "ENTERPRISEPACK"}|select *
$licenses|select $ServicePackageName,$ServiceNames,$ServiceCount|fl

#write all users and their respective licenses
ForEach ($user in $licensedUsers) {
    $LicenseList = Get-AzureADUser -ObjectID $user.UserPrincipalName | Select -ExpandProperty AssignedLicenses | Select SkuID
    Write-Host ""
    Write-Host "$($user.UserPrincipalName) has the following licenses"
    Write-Host "===================================================="
    $LicenseList | ForEach { $sku=$_.SkuId ; $licensePlanList | ForEach { If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) { Write-Host $_.SkuPartNumber } } }
}
