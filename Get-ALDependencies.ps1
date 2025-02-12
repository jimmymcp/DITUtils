function Get-ALDependencies {
    param(
        [string]$appJsonPath = (Join-Path (Get-Location) 'app.json'),
        [string]$packagesPath = (Get-PackagesPath),
        [switch]$Install,
        [string]$ContainerName = (Get-RunningContainerName),
        [pscredential]$Credential = (Get-DefaultContainerCredential)
    )

    "Packages Path: $packagesPath"
    if (!(Test-Path $packagesPath)) {
        New-Item $packagesPath -ItemType Directory | Out-Null
    }

    $originalPath = Get-Location

    $tempPath = Join-Path 'C:\Temp' ([Guid]::NewGuid().Guid)
    New-Item $tempPath -ItemType Directory | Out-Null
    
    $appJson = Get-Content $appJsonPath -Raw | ConvertFrom-Json
    Set-Location $tempPath
    $appJson.dependencies | ForEach-Object {
        $packageId = "$($_.Publisher.Replace(' ','')).$($_.Name.Replace(' ','')).$($_.id)"
        nuget install $packageId
    }

    Get-ChildItem -Path $tempPath -Filter *.app -Recurse | ForEach-Object {
        $_.Name
        Copy-Item $_.FullName $packagesPath -Force
    }

    Set-Location $originalPath

    if ($Install.IsPresent) {
        Install-AppsFromFolder -SourcePath $packagesPath -ContainerName $ContainerName -Credential $Credential
    }
}

Export-ModuleMember -Function Get-ALDependencies