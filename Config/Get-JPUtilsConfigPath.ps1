function Get-JPUtilsConfigPath {
    Join-Path $env:USERPROFILE 'JPUtils.json'
}

Export-ModuleMember -Function Get-JPUtilsConfigPath