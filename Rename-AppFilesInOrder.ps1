function Rename-AppFilesInOrder {
    param(
        [string]$Path
    )

    $files = @()
    Get-ChildItem $Path -Filter *.app | % { $files += $_.FullName }

    $apps = Sort-AppFilesByDependencies -appFiles $files

    [int]$i = 10
    $apps | ForEach-Object {
        Rename-Item $_ (Join-Path (Split-Path $_ -Parent) ("$i $(Split-Path $_ -Leaf)"))
        $i += 1
    }
}

Export-ModuleMember -Function Rename-AppFilesInOrder