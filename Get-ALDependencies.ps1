function Get-ALDependencies {
    param(
        [string]$appJsonPath = (Join-Path . 'app.json'),
        [string]$packagesPath = (Join-Path . '.alpackages')
    )

    if (!(Test-Path $packagesPath)) {
        New-Item $packagesPath -ItemType Directory | Out-Null
    }

    $tempPath = Join-Path $env:TEMP ([Guid]::NewGuid().Guid)
    New-Item $tempPath -ItemType Directory | Out-Null

    $appJson = Get-Content $appJsonPath -Raw | ConvertFrom-Json
    $appJson.dependencies | Where-Object Publisher -ne Microsoft | ForEach-Object {
        $packageId = "$($_.Publisher.Replace(' ','')).$($_.Name.Replace(' ','')).$($_.id)"
        nuget install $packageId -outputDirectory $tempPath
    }

    Get-ChildItem -Path $tempPath -Filter *.app -Recurse | ForEach-Object {
        $_.Name
        Copy-Item $_.FullName $packagesPath -Force
    }
}

Export-ModuleMember -Function Get-ALDependencies