function Get-ChangeLog {
    param(
        [Parameter(Mandatory = $true)]
        [int]$featureNo,
        [switch]$includeDescription
    )

    $result = @()

    $feature = Invoke-AzureDevOpsAPI -url "wit/workitems/$featureNo" -method Get -params @{'$expand' = 'Relations' }
    $changedDate = $feature.fields.'System.ChangedDate'

    # parent
    $feature.relations | Where-Object rel -eq 'System.LinkTypes.Hierarchy-Reverse' | ForEach-Object {
        $item = Invoke-AzureDevOpsAPI -url $_.url -params @{fields = 'System.Title,System.ChangedDate' }
        $result += "### $($item.fields.'System.Title') $($feature.fields.'System.Title') ($($changedDate.Day)/$($changedDate.Month)/$($changedDate.Year))"
    }

    #children
    $feature.relations | Where-Object rel -eq 'System.LinkTypes.Hierarchy-Forward' | ForEach-Object {
        $item = Invoke-AzureDevOpsAPI -url $_.url -params @{fields = 'System.Title,System.Description' }
        $result += "- [$($item.id)](https://dev.azure.com/TES365/TES%20IP/_workitems/edit/$($item.id)): $($item.fields.'System.Title')"
        if ($includeDescription) {
            $result += $item.fields.'System.Description'
            $result += ''
            $result += '<hr/>'
            $result += ''
        }
    }

    $result
    $result | Set-Clipboard
}

Export-ModuleMember -Function Get-ChangeLog