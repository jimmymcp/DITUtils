function Select-AppFromNuGetFeed {
    param(
        [ValidateSet('TESRelease','TES')]
        $source
    )

    $result = nuget list -source $source | ConvertFrom-Csv -Delimiter ' ' -Header ('App', 'Version')
    $result | Where-Object {$_.Version -match '\d.\d.\d'} | Out-GridView -Title 'Select an app' -OutputMode Single
}

Export-ModuleMember -Function Select-AppFromNuGetFeed