# WARNING
# This will break o365 sessions by deleting it's variables
$ps = [PowerShell]::Create()
$ps.AddScript('Get-Variable | Select-Object -ExpandProperty Name') | Out-Null
$builtIn = $ps.Invoke()
$ps.Dispose()
$builtIn += "profile","psISE","psUnsupportedConsoleApplications" # keep some ISE-specific stuff

Remove-Variable (Get-Variable | Select-Object -ExpandProperty Name | Where-Object {$builtIn -NotContains $_})
