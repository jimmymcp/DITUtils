function Create-Release {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Version
    )

    $VersionElements = $Version.Split('.')
    for ($i = $VersionElements.Count; $i -lt 4; $i++) {
        $Version += '.0'
    }

    if ((Read-Host "Creating version $Version. Continue?").ToLower() -ne 'y') {
        throw "Cancelled"
    }

    git checkout -b "v$Version"
    git checkout -b "v$Version-TEST"
}

Export-ModuleMember -Function Create-Release