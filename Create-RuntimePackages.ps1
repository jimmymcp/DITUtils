function Create-RuntimePackages {
    param(
        [Parameter(Mandatory = $true)]
        [string]$AppsPath,
        [Parameter(Mandatory = $true)]
        [string]$Destination,
        [Parameter(Mandatory = $false)]
        [bool]$IncludeSource = $false,
        [Parameter(Mandatory = $false)]
        [int]$NoOfPreviousMajorVersions
    )

    $versions = Get-BCVersions -NoOfPreviousMajorVersions $NoOfPreviousMajorVersions
    $versions | % {
        $versionDestination = (Join-Path $Destination $_)
        if (!(Test-Path $versionDestination)) {
            New-Item -ItemType Directory -Path $versionDestination
        }

        Convert-BcAppsToRuntimePackages -containerName convert -artifactUrl (Get-ArtifactUrl -ContainerType Sandbox -Version $_) `
            -apps $AppsPath -destinationFolder $versionDestination -includeSourceInPackageFile $IncludeSource
        Flush-ContainerHelperCache
    }
}

Export-ModuleMember Create-RuntimePackages