function Install-AppsFromFolder {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContainerName,
        [pscredential]$credential = (Get-Credential),
        [string]$SourcePath = (Get-Location),
        [switch]$GlobalScope
    )

    Sort-AppFilesByDependencies -appFiles (gci $SourcePath -Recurse -Filter *.app | % {
            $_.FullName
        }) -containerName $ContainerName | % {
        if ($GlobalScope.IsPresent) {
            try {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode ForceSync -install -skipVerification
            }
            catch {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode ForceSync -upgrade -skipVerification
            }
        }
        else {
            try {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode Development -upgrade -skipVerification -useDevEndpoint -credential $credential
            }
            catch {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode Development -install -skipVerification -useDevEndpoint -credential $credential
            }
        }
    }
}

Export-ModuleMember -Function Install-AppsFromFolder