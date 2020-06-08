#You could create an email transport filter to target things you've seen being sent to your users.
#You can keep track of it with the following commands.
Get-TransportRule -Identity "*ransomware*"
Get-TransportRule -Identity "*ransomware*"|select name,AttachmentExtensionMatchesWords|Format-Table -Wrap
Get-TransportRule -Identity "*ransomware*"|select name,description |Format-Table -Wrap
