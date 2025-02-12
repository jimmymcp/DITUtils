function Test-AdminAppAccess {
    Param(
        [string]$DomainName
    )

    try {
        New-EnvironmentAdminAuth -DomainName $DomainName
        return $true
    }
    catch {
        return $false
    }
}

Export-ModuleMember -Function Test-AdminAppAccess