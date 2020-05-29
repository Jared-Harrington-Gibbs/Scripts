#Stop annoying bell when pressing backspace on empty prompt
Set-PSReadlineOption -BellStyle None

#Linux like tab completion for parameters
Set-PSReadlineOption -EditMode Emacs

#Customize default command line look/feel
function prompt {
    $CurrentPath = Split-Path -leaf -path (Get-Location)
    $CurrentUserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name|Split-Path -Leaf
    "($CurrentUserName): $CurrentPath> "
  }

# add two functions for cross terminal searchable history
function histGrep {get-content (Get-PSReadLineOption).HistorySavePath | Select-String -Pattern "$args"}
function grepHist {get-content (Get-PSReadLineOption).HistorySavePath | Select-String -Pattern "$args"}

# add two functions for recursive paths
function lr {Get-ChildItem -Recurse -File |Select-Object FullName}
function lrr {Get-ChildItem -Recurse -File |ForEach-Object {Resolve-Path $_.FullName -Relative}}
