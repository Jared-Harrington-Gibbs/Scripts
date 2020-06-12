#connect to services
Connect-AzureAD
Connect-MsolService

#get tenant info
$allUsersList=Get-AzureADUser -All $true
$MsolSubscription =  Get-MsolSubscription
$AzureADSubscribedSku = Get-AzureADSubscribedSku

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

#write all users and their respective licenses
ForEach ($user in $licensedUsers) {
    $LicenseList = $user | Select -ExpandProperty AssignedLicenses | Select SkuID
    Write-Host ""
    Write-Host "$($user.UserPrincipalName) has the following licenses"
    Write-Host "===================================================="
    $LicenseList | ForEach { $sku=$_.SkuId ; $AzureADSubscribedSku | ForEach { If ( $sku -eq $_.ObjectId.substring($_.ObjectId.length - 36, 36) ) { Write-Host $_.SkuPartNumber } } }
}

#set calculated properties. For more info see: https://mcpmag.com/articles/2017/01/19/using-powershell-calculated-properties.aspx
$ServicePackageName = @{name="ServicePackageName";e={$_.SkuPartNumber}}
$ServiceCount = @{name="ServiceCount";e={($_.serviceplans).count}}
$ServiceNames = @{name="ServiceNames";e={$_.serviceplans.ServicePlanName}}

#write skus and their included plans
$AzureADSubscribedSku|select $ServicePackageName,$ServiceNames,$ServiceCount|fl

#filter for specific skus
$licenses = $AzureADSubscribedSku |where {$_.skupartnumber -eq "EMS" -or $_.skupartnumber -eq "ATP_ENTERPRISE"}|select *
$licenses|select $ServicePackageName,$ServiceNames,$ServiceCount|fl


# show info about specific sku(s)
$AzureADSubscribedSku |where {$_.skupartnumber -eq "ENTERPRISEPREMIUM"}|select skupartnumber,consumedunits -ExpandProperty PrepaidUnits |ft

# show info about specific subscription(s)
$MsolSubscription | where {$_.skupartnumber -like "*PREMIUM"}|select SkuPartNumber,Status,TotalLicenses,DateCreated,NextLifecycleDate,istrial|ft

# show info about all warning sku(s)
$AzureADSubscribedSku |where {$_.prepaidunits.warning -ne "0"}|select skupartnumber,consumedunits -ExpandProperty PrepaidUnits |ft


# show info about all abnormal state subscription(s)
$MsolSubscription | where {$_.status -ne "enabled"}|select SkuPartNumber,Status,TotalLicenses,DateCreated,NextLifecycleDate,istrial|ft
