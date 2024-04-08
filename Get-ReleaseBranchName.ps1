function Get-ReleaseBranchName {
    (git branch | Where-Object {$_.TrimStart().StartsWith('release/')} | Sort-Object -Descending | Select-Object -First 1).Trim()
}

Export-ModuleMember -Function Get-ReleaseBranchName