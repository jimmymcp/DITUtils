$ExcludeFolders = ('scripts')

Get-ChildItem $PSScriptRoot -File -Recurse -Filter *.ps1 | ForEach-Object {
    if (!($ExcludeFolders.Contains($_.Directory.Name))) {
        .($_.FullName)
    }
}