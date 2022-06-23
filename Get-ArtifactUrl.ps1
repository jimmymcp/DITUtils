function Get-ArtifactUrl {
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('Sandbox','OnPrem')]
        [string]$ContainerType = 'Sandbox',
        [Parameter(Mandatory=$false)]
        [string]$Version,
        [Parameter(Mandatory=$false)]
        [string]$Country = 'w1',
        [Parameter(Mandatory=$false)]
        [ValidateSet('bcartifacts','bcinsider')]
        [string]$StorageAccount = 'bcartifacts',
        [Parameter(Mandatory=$false)]
        [switch]$SecondToLastMajor
    )

    $ArtifactParams = @{
        type = $ContainerType
        storageAccount = $StorageAccount
        country = $Country
    }

    if ($null -ne $Version) {
        $ArtifactParams.Add('version', $Version)
    }

    if ($StorageAccount -eq 'bcinsider') {
        $ArtifactParams.Add('sasToken', (Get-TFSConfigKeyValue -KeyName 'sasToken'))
    }

    if ($SecondToLastMajor.IsPresent) {
        $ArtifactParams.Add('select', 'SecondToLastMajor')
    }

    $ArtifactUrl = Get-BCArtifactUrl @ArtifactParams

    # if no url has been found then look for it in the bcinsider storage account
    if (($null -eq $ArtifactUrl) -and ($StorageAccount -eq 'bcartifacts')) {
        $ArtifactParams.Remove('storageAccount')
        $ArtifactParams.Add('storageAccount','bcinsider')
        $ArtifactParams.Add('sasToken', (Get-TFSConfigKeyValue -KeyName 'sasToken'))
        $ArtifactUrl = Get-BCArtifactUrl @ArtifactParams
    }

    # if still no url has been found then look for it as an on-prem artifact
    if (($null -eq $ArtifactUrl) -and ($ContainerType -eq 'Sandbox')) {
        $ArtifactParams.Remove('storageAccount')
        $ArtifactParams.Add('storageAccount','bcartifacts')
        $ArtifactParams.Remove('sasToken')
        $ArtifactParams.Remove('type')
        $ArtifactParams.Add('type', 'OnPrem')
        $ArtifactUrl = Get-BCArtifactUrl @ArtifactParams
    }

    $ArtifactUrl
}

Export-ModuleMember -Function Get-ArtifactUrl