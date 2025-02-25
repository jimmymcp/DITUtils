function Get-ReleaseBranchName {
    $releaseBranches = @()
    git branch | Where-Object {$_.TrimStart().StartsWith('release/')} | ForEach-Object {
        $releaseBranch = @{
            Name = $_.Trim()
            Version = [Version]::Parse($_.Trim().TrimStart('release/'))
        }
        $releaseBranches += $releaseBranch
    }
    ($releaseBranches | Sort-Object -Property Version -Descending | Select-Object -First 1).Name
}

Export-ModuleMember -Function Get-ReleaseBranchName