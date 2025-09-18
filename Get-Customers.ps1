function Get-Customers {
    param(
        [Parameter(Position = 1, Mandatory=$false)]
        [string]$search
    )
    $customers = Get-Content (Join-Path ([Environment]::GetFolderPath('userprofile')) "Downloads\Customers.csv") -Raw | ConvertFrom-Csv -Header ('MicrosoftID', 'CompanyName', 'PrimaryDomainName', 'Relationship', 'Tags') | Select-Object -Skip 1
    if ($search) {
        $customers = $customers | Where-Object {$_.PrimaryDomainName -like "*$($search)*" -or $_.CompanyName -like "*$($search)*"}
    }
    $customers
}

Export-ModuleMember -Function Get-Customers