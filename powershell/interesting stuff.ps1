#search command history
Get-Content (Get-PSReadlineOption).HistorySavePath |Select-String -Pattern ".*search here.*"

#search event logs
Get-EventLog -LogName Security -InstanceId 4729,4733,4757,4728,4732,4756

Get-WinEvent -ListProvider * |where {$_.name -like "*sysmon*"}

Get-WinEvent -ProviderName Microsoft-Windows-Sysmon -MaxEvents 10

Get-WinEvent -FilterHashtable @{logname="*system*";id=1014;}|Where-Object {$_.message -imatch ".*steam.*"}|Select-Object id,message |Format-List

Get-WinEvent -ProviderName Microsoft-Windows-Sysmon -FilterXPath "*[System[EventID=1] and EventData[Data[@Name='ProcessId']='22964']]"

Get-WinEvent -FilterHashtable @{providername="*sysmon*";id=12,13,14} -MaxEvents 200 | Where-Object {$_.message -imatch ".*winlogon.*"}|select id,message |fl


#get username
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).Identity.Name

#get is admin
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)



#uninstall stuff (warning may reboot machine without asking)
$programs = @(“program1”, “program2”, “program3”)
foreach($program in $programs){
    $app = Get-WmiObject -Class Win32_Product | Where-Object {
        $_.Name -match “$program”
    }
    $app.Uninstall()
}


#find into about what/where modules/commands are from
Get-Command -Module PowerShellGet
Get-Command -Module PackageManagement
Get-Command install-module | select ModuleName
Get-InstalledModule
Get-Module

#Make lists unlimited lenght!!!
$FormatEnumerationLimit=-1

#change layout Hotkey from ctrl+shift to left alt+shift
set-ItemProperty 'HKCU:\Keyboard Layout\Toggle\' -Name "Layout Hotkey" -Value 1

#change Language Input Hotkey from left alt+shift to disabled
Set-ItemProperty 'HKCU:\Keyboard Layout\Toggle\' -Name "Language Hotkey" -Value 3
