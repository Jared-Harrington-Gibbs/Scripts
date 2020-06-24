#This manually specifies to update modules if update-help isn't getting everything.
$modules = (Get-InstalledModule).Name
$modules | ForEach-Object {Update-Help -Module $_ -Force -ErrorAction SilentlyContinue}
