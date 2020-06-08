Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

#Compare goal to current state
$extensionsTarget=("docm", "dotm", "xlm", "xlsm", "ppam", "xltm", "xlam", "pptm", "potm", "ppsm", "sldm")

$current=Get-TransportRule -Identity "*Warn about office documents*"|select -ExpandProperty AttachmentExtensionMatchesWords

Write-Host "add these to the rule"
Compare-Object $extensionsTarget $current | Where-Object {$_.SideIndicator -eq "<="}

Write-Host "remove these from the rule"
Compare-Object $extensionsTarget $current | Where-Object {$_.SideIndicator -eq "=>"}
