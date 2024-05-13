function Get-RunningContainerName {
    $RunningContainers = docker ps --format json | ConvertFrom-Json | Select-Object Names
    if ($RunningContainers.Count -eq 1) {
        return $RunningContainers[0].Names
    }
    elseif ($RunningContainers.Count -gt 1) {
        $Containers = @()
        $RunningContainers | ForEach-Object {
            $Containers += $_.Names
        }
        return Get-SelectionFromUser $Containers -Prompt "Select a container:"
    }
    else {
        Write-Host "No containers are running."
    }
}

Export-ModuleMember -Function Get-RunningContainerName