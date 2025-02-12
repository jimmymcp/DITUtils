function Get-PackagesPath {
    $path = Get-DITUtilsConfig -KeyName 'packagesPath'
    if (![String]::IsNullOrEmpty($path)) {
        return $path
    }

    Join-Path (Get-Location) '.alpackages'
}

Export-ModuleMember -Function Get-PackagesPath