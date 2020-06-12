#Because I keep forgetting how to connect to sharepoint

$orgName="OrgNameHere"

#Parameters
$TenantURL = "https://$orgName.sharepoint.com"
 
#Tenant Admin URL
$TenantAdminURL = "https://$orgName-admin.sharepoint.com"

#PNP connect to Admin Center
Connect-PnPOnline -Url $TenantAdminURL -UseWebLogin
#or
Connect-PnPOnline -Url $TenantAdminURL -SPOManagementShell

#SPO connect to Admin Center
Connect-SPOService -Url https://$orgName-admin.sharepoint.com
