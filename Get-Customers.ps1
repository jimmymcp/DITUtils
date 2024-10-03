function Get-Customers {
    Get-Content (Join-Path ([Environment]::GetFolderPath('userprofile')) "Downloads\Customers.csv") -Raw | ConvertFrom-Csv -Header ('MicrosoftID', 'CompanyName', 'PrimaryDomainName', 'Relationship', 'Tags') | Select-Object -Skip 1
}

Export-ModuleMember -Function Get-Customers