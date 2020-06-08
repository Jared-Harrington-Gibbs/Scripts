Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

#Compare goal to current state
$scriptsTarget=("bat", "exe", "hta", "jse", "lnk", "msi", "reg", "vbs")

$current=Get-TransportRule -Identity "*Block scripts and programs*"|select -ExpandProperty AttachmentExtensionMatchesWords

Write-Host "add these to the rule"
Compare-Object $scriptsTarget $current | Where-Object {$_.SideIndicator -eq "<="}

Write-Host "remove these from the rule"
Compare-Object $scriptsTarget $current | Where-Object {$_.SideIndicator -eq "=>"}
