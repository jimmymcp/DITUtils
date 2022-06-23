gci $PSScriptRoot -Recurse -Filter *.ps1 | % {
    .($_.FullName)
}