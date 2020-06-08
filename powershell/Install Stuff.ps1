#######################
#Install and Setup WSL#
#######################

Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

#need to be on the insider program
#wsl --set-default-version 2


#################
#Install Profile#
#################
$Profileps1 = Invoke-WebRequest -UseBasicParsing `
                                -Uri "https://raw.githubusercontent.com/Jared-Harrington-Gibbs/Scripts/master/powershell/Profile.ps1" `
                                -Method Get
                                
Write-Host '$Profileps1 contains' -ForegroundColor green
Write-Host "$($Profileps1.content)" -ForegroundColor Cyan

$install = Read-Host -Prompt "Would you like to append this profile to $($PROFILE)? y/N"

if ($install -icontains "y") {
    New-Item -Force -Path $PROFILE -Value $Profileps1.Content -Type File
} else {
    Write-Host "Profile not installed to $PROFILE"
}

########################
#Install powershell 7 #
########################
Invoke-WebRequest -UseBasicParsing -Method Get -Uri
https://github.com/PowerShell/PowerShell/releases/download/v7.0.1/PowerShell-7.0.1-win-x64.msi -OutFile
PowerShell-7.0.1-win-x64.msi

#should match e652a8e0f7d088106ea018d4b9e02373d4331907efa64a60dc32e097b165d8fd
certutil -hashfile .\PowerShell-7.0.1-win-x64.msi SHA256

.\PowerShell-7.0.1-win-x64.msi
