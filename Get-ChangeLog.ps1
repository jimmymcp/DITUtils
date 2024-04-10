function Get-ChangeLog {
    param(
        [Parameter(Mandatory = $true)]
        [int]$featureNo
    )

    $result = @()
    $firstChild = $true

    $feature = Invoke-AzureDevOpsAPI -url "wit/workitems/$featureNo" -method Get -params @{'$expand' = 'Relations' }
    $changedDate = $feature.fields.'System.ChangedDate'

    # version no. header
    $result += "### $($feature.fields.'System.Title') ($($changedDate.Day)/$($changedDate.Month)/$($changedDate.Year))"

    #children
    $feature.relations | Where-Object rel -eq 'System.LinkTypes.Hierarchy-Forward' | ForEach-Object {
        $item = Invoke-AzureDevOpsAPI -url $_.url -params @{fields = 'System.Title,Custom.ReleaseNotes' }
        if (!($firstChild)) {
            $result += '<hr/>'
            $result += ''
        }
        $result += "- [$($item.id)](https://dev.azure.com/TES365/TES%20IP/_workitems/edit/$($item.id)): $($item.fields.'System.Title')"
        $result += $item.fields.'Custom.ReleaseNotes'
        $result += ''
        $firstChild = $false
    }

    $result
    $result | Set-Clipboard
}

Export-ModuleMember -Function Get-ChangeLog