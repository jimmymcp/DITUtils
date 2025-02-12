function New-EnvironmentAdminAuth {
    Param(
        [string]$DomainName
    )

    New-BcAuthContext -Tenant $DomainName -clientID (Get-DITUtilsConfig 'environmentAdminClientID') -clientSecret (Get-DITUtilsConfig 'environmentAdminClientSecret')
}

Export-ModuleMember -Function New-EnvironmentAdminAuth