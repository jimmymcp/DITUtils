function Install-AppsFromFolder {
    param(
        [string]$ContainerName = (Get-RunningContainerName),
        [pscredential]$credential = (Get-DefaultContainerCredential),
        [string]$SourcePath = (Get-Location),
        [switch]$GlobalScope
    )

    Sort-AppFilesByDependencies -appFiles (Get-ChildItem $SourcePath -Recurse -Filter *.app | ForEach-Object {
            if (-not $_.Name.StartsWith('Microsoft') -and -not $_.Name.StartsWith('System')) {
                $_.FullName
            }
        }) -containerName $ContainerName | ForEach-Object {
        if ($GlobalScope.IsPresent) {
            try {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode ForceSync -install -skipVerification -ignoreIfAppExists
            }
            catch {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode ForceSync -upgrade -skipVerification -ignoreIfAppExists
            }
        }
        else {
            try {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode Development -upgrade -skipVerification -useDevEndpoint -credential $credential -ignoreIfAppExists
            }
            catch {
                Publish-BcContainerApp $ContainerName -appFile $_ -sync -syncMode Development -install -skipVerification -useDevEndpoint -credential $credential -ignoreIfAppExists
            }
        }
    }
}

Export-ModuleMember -Function Install-AppsFromFolder