function Test-AdminAppAccess {
    Param(
        [string]$DomainName
    )

    return (Invoke-WebRequest "$(Get-DitUtilsConfig -KeyName environmentAdminUrl)?tenantId=$DomainName").Content
}

Export-ModuleMember -Function Test-AdminAppAccess