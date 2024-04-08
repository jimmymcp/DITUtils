function Get-AppFromNuGet {
    param(
        $app,
        [ValidateSet('TESRelease','TES')]
        $source = 'TESRelease',
        $path = 'C:\TES',
        [switch]$openExplorer
    )

    if ([String]::IsNullOrEmpty($app)) {
        $app = (Select-AppFromNuGetFeed -source $source)
    }

    nuget install $($app.App) -source $source -fallbacksource https://dynamicssmb2.pkgs.visualstudio.com/DynamicsBCPublicFeeds/_packaging/MSApps/nuget/v3/index.json -dependencyversion Highest -outputDirectory $path

    $appPath = Get-ChildItem -Path (Get-ChildItem $path -Filter "$($app.App).$($app.Version)*" -Directory | Select-Object -First 1).FullName -Filter *.app | Select-Object FullName -First 1
    $appPath

    if ($openExplorer.IsPresent) {
        Start-Process explorer (Split-Path $appPath -Parent)
    }
}

Export-ModuleMember -Function Get-AppFromNuGet