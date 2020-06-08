#SharePoint Online Management Shell
#https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online?view=sharepoint-ps
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force #-Scope CurrentUser

#Newest Azure Active Directory Preview PowerShell module
#Uninstall-Module AzureAD
Install-module AzureADPreview -Force #-Scope CurrentUser

#Newer Azure Active Directory V2 PowerShell module
#https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0#installing-the-azure-ad-module
#Install-Module -Name AzureAD -Force #-Scope CurrentUser

#Older Azure Active Directory V1 (MSOnline) PowerShell module
#https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0#installing-the-azure-ad-module
#Install-Module -Name MSOnline -Force #-Scope CurrentUser

#Exchange Online PowerShell V2
#https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2?view=exchange-ps#install-the-exo-v2-module
#winrm get winrm/config/client/auth
Install-Module -Name ExchangeOnlineManagement -Force #-Scope CurrentUser

#Teams PowerShell module
#https://docs.microsoft.com/en-us/MicrosoftTeams/teams-powershell-overview#which-modules-do-you-need-to-use
Install-Module -Name MicrosoftTeams -Force #-Scope CurrentUser

#Microsoft 365 Desired State Configuration Tool.
#https://github.com/microsoft/Microsoft365DSC
#AllowClobber is needed because the 'AzureADPreview' dependency overrides some commands from the 'AzureAD' package
Install-Module -Name Microsoft365DSC -AllowClobber -Force #-Scope CurrentUser 

# TODO: Find a way to install skype online manager with powershell
