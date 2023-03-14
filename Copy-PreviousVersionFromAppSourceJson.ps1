function Copy-PreviousVersionFromAppSourceJson {
    param(
        [string]$ProjectRoot = (Get-Location)
    )

    $AppSourceCop = Get-Content (Join-Path $ProjectRoot 'AppSourceCop.json') -Raw | ConvertFrom-Json
    $AppJson = Get-Content (Join-Path $ProjectRoot 'app.json') -Raw | ConvertFrom-Json
    $AppFileName = "$($AppJson.Publisher)_$($AppJson.Name)_$($AppSourceCop.version).app"

    $Apps = Get-ChildItem -Path (Get-DITUtilsConfig -KeyName releasesPath) -Filter $AppFileName -Recurse | Select -Last 1
    
    if ($null -ne $Apps) {
        $AppPath = $Apps.FullName
        Copy-Item $AppPath (Join-Path $ProjectRoot '.alpackages')
        "Copied $AppPath"
    }
    else {
        "Couldn't find $AppFileName in the releases folder"
    }
}

Export-ModuleMember .\Copy-PreviousVersionFromAppSourceJson