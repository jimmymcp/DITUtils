function Get-ContainerErrors {
    param(
      [Parameter(Mandatory = $true)]
      [string]$ContainerName,
      [Parameter(Mandatory = $false)]
      [int]$Newest = 1
    )
    docker exec $ContainerName powershell ("Get-EventLog Application -EntryType Error -Newest $Newest" + ' | % {$_.Message;''**********''}')
  }

  Export-ModuleMember -Function Get-ContainerErrors