function Get-BCContainerAppInfoSummary {
    $Container = Get-RunningContainerName
    if (!([String]::IsNullOrEmpty($Container))) {
        Get-BCContainerAppInfo $Container | Select-Object Publisher, Name, Version, AppID | Where-Object Publisher -ne Microsoft | Sort-Object Publisher, Name, Version
    }
}

Export-ModuleMember -Function Get-BCContainerAppInfoSummary