#Install and Setup WSL
Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

#Set WSL Version 2
wsl --set-default-version 2

#Install Profile
$Profileps1 = Invoke-WebRequest -UseBasicParsing `
                                -Uri "https://raw.githubusercontent.com/Jared-Harrington-Gibbs/Scripts/master/powershell/Profile.ps1" `
                                -Method Get
