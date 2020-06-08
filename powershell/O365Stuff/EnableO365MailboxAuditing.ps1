#Copied the now deleted EnableMailboxAuditing.ps1 from the OfficeDev repo. OfficeDev/O365-InvestigationTooling@9e79333
#This script will enable non-owner mailbox access auditing on every mailbox in your tenancy

#This gets us connected to an Exchange remote powershell service
import-module ExchangeOnlineManagement
Connect-ExchangeOnline

#Get the mailboxes!!!!
Write-Output "Getting a list of mailboxes in the tenant." `
"Please be patient this can take a while."
[array]$mailboxList = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"}



#Enable global audit logging
$itemNumber = 1
foreach ($mailbox in $mailboxList)
{
    try
    {
        Write-Progress -Activity "Updating $($mailbox.WindowsEmailAddress)" `
                       -Status "User $($itemnumber) of $($mailboxList.count)" `
                       -PercentComplete (($itemnumber*100)/$mailboxList.Count)
        
        $itemNumber++

        Set-Mailbox -Identity $mailbox.DistinguishedName -AuditEnabled $true -AuditLogAgeLimit 180 -AuditAdmin Update, MoveToDeletedItems, SoftDelete, HardDelete, SendAs, SendOnBehalf, Create, UpdateFolderPermission -AuditDelegate Update, SoftDelete, HardDelete, SendAs, Create, UpdateFolderPermissions, MoveToDeletedItems, SendOnBehalf -AuditOwner UpdateFolderPermission, MailboxLogin, Create, SoftDelete, HardDelete, Update, MoveToDeletedItems
        
    }
    catch
    {
        Write-Warning $_.Exception.Message
    }
}

#Double-Check It!
Get-Mailbox -ResultSize Unlimited | Select Name, AuditEnabled, AuditLogAgeLimit
