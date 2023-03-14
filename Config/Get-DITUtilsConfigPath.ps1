function Get-DITUtilsConfigPath {
    Join-Path $env:USERPROFILE 'DITUtils.json'
}

Export-ModuleMember -Function Get-DITUtilsConfigPath