function Get-JPUtilsConfig {
    param(
        [Parameter(Mandatory = $false)]
        [string]$KeyName = ''
    )
    if (!(Test-Path (Get-JPUtilsConfigPath))) {
        Set-Content -Path (Get-JPUtilsConfigPath) -Value '{}'
    }

    if ($KeyName -ne '') {
        (Get-Content (Get-JPUtilsConfigPath) | ConvertFrom-Json)."$KeyName"
    }
    else {
        Get-Content (Get-JPUtilsConfigPath) | ConvertFrom-Json
    }
}

Export-ModuleMember -Function Get-JPUtilsConfig