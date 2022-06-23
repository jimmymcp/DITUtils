function List-ALObjects {
    gci . -Recurse -Filter *.al | % { 
        (gc $_.FullName).Item(0) + "~" + [Regex]::Match((gc $_.FullName -Raw), 'Access.*=.*;') } | sort | ConvertFrom-String -Delimiter '~' -PropertyNames ('Object', 'Access') 
}

Export-ModuleMember -Function List-ALObjects