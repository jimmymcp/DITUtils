function Get-DITUtilsConfig {
    param(
        [Parameter(Mandatory = $false)]
        [string]$KeyName = ''
    )
    if (!(Test-Path (Get-DITUtilsConfigPath))) {
        Set-Content -Path (Get-DITUtilsConfigPath) -Value '{}'
    }

    if ($KeyName -ne '') {
        (Get-Content (Get-DITUtilsConfigPath) | ConvertFrom-Json)."$KeyName"
    }
    else {
        Get-Content (Get-DITUtilsConfigPath) | ConvertFrom-Json
    }
}

Export-ModuleMember -Function Get-DITUtilsConfig