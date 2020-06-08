#Install and Setup WSL
Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -All -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

#Set WSL Version 2
wsl --set-default-version 2
