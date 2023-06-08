function Get-BCVersions {
    param(
        [int]$NoOfPreviousMajorVersions = 1
    )

    [version]$latestVersion = [Version]::Parse((Get-ArtifactUrl).Split('/').Item(4))
    $major = $latestVersion.Major
    $minor = $latestVersion.Minor
    for ($i = 0; $i -le $NoOfPreviousMajorVersions; $i++) {
        if ($i -gt 0) {
            $minor = 5
        }

        for ($j = $minor; $j -ge 0; $j--) {
            "$($major - $i).$j"
        }
    }
}

Export-ModuleMember -Function Get-BCVersions