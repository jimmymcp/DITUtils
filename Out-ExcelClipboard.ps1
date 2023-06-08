function Out-ExcelClipboard {
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        $InputObject
    )
    begin {
        $Objects = @()
    }
    process {
        $Objects += $InputObject
    }
    end {
        $Objects | ConvertTo-Csv -Delimiter "`t" -NoTypeInformation | Set-Clipboard
    }
}

Export-ModuleMember -Function Out-ExcelClipboard