Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

function main {
    #change the default settings
    Get-CASMailboxPlan | Set-CASMailboxPlan -ImapEnabled $false -PopEnabled $false
    
    [array]$nonCompliantMailboxes = Get-NonCompliantMailboxes
    
    #set all users individually to match the default
    $itemNumber = 1
    foreach ($user in $nonCompliantMailboxes)
    {
        try
        {
            Write-Progress -Activity "Updating $($user.Identity)" `
                        -Status "User $($itemnumber) of $($nonCompliantMailboxes.count)" `
                        -PercentComplete (($itemnumber*100)/$nonCompliantMailboxes.Count)
            
            $itemNumber++

            Set-CasMailbox -Identity $user.Identity -PopEnabled $false -ImapEnabled $false  -SmtpClientAuthenticationDisabled $true
        }
        catch
        {
            Write-Warning $_.Exception.Message
        }
    }

    Write-Host "Completed Updating Users"
    
    [array]$nonCompliantMailboxes = Get-NonCompliantMailboxes
}

function Get-NonCompliantMailboxes {
    # $nonCompliantMailboxes = Get-CASMailbox -ResultSize Unlimited `
    #                                         -filter {PopEnabled -ne $false -or ImapEnabled -ne $false} | 
    #                          where {$_.PopEnabled -ne $false -or `
    #                                 $_.ImapEnabled -ne $false -or  `
    #                                 $_.SmtpClientAuthenticationDisabled -ne $true}

    #find any users who don't have the correct settings
    #force cast to array in case there is only one item
    [array]$nonCompliantMailboxes = Get-CASMailbox -ResultSize Unlimited | 
        where {$_.PopEnabled -ne $false -or $_.ImapEnabled -ne $false -or $_.SmtpClientAuthenticationDisabled -ne $true}


    if (($nonCompliantMailboxes).Count)
    {
        Write-Host "There are $($nonCompliantMailboxes.Count) non-compliant accounts."
    }else
    {
        Write-Host "All accounts are compliant."
    }
    return $nonCompliantMailboxes
}

#call main function
main
