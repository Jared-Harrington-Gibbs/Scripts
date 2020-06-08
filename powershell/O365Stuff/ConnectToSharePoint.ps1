#Because I keep forgetting how to connect to sharepoint

$orgName=(Get-OrganizationConfig |select -ExpandProperty name).split(".")[0]
#or
$orgName="OrgNameHere"

Connect-SPOService -Url https://$orgName-admin.sharepoint.com
