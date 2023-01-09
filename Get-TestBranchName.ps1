function Get-TestBranchName {
    (git branch | Where-Object {$_.endsWith('-TEST')} | Sort-Object -Descending | Select-Object -First 1).Trim()
}

Export-ModuleMember -Function Get-TestBranchName