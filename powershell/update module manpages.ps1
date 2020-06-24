$modules = (Get-InstalledModule).Name
$modules | ForEach-Object {Update-Help -Module $_ -Force -ErrorAction SilentlyContinue}
