function List-AppsInBCContainer {
    param(
      [string]$ContainerName = ''
    )
  
    if ('' -eq $ContainerName) {
      if ((docker ps -q).Count -eq 1) {
        $ContainerName = (docker inspect (docker ps -q) | ConvertFrom-Json).config.hostname
      }
    }
  
    if ('' -eq $ContainerName) {
      Write-Host "Container Name:"
      $ContainerName = Read-Host
    }
  
    Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties | ? Publisher -ne Microsoft | sort name | select appId, name, version, isinstalled, scope | Format-Table
  }

Export-ModuleMember -Function List-AppsInBCContainer