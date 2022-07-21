function List-Commits {
    param(
        $Days = 7
    )
    cd 'C:\Git'
    $Commits = @()
    $SinceDate = (Get-Date).AddDays("-$Days").ToShortDateString()
    Write-Host "Listing commits in $(Get-Location) since $SinceDate"
    Get-ChildItem . -Directory | % {
        cd "$_"
        if (Test-Path (Join-Path (Get-Location) '.git')) {
            $Commits += git log --all --format="$($_)~%h~%ai~%s~%an" --since="\"$SinceDate\"" | ConvertFrom-Csv -Delimiter '~' -Header ('Project,Hash,Date,Message,Author'.Split(','))
        }
        cd ..
    }
    $Commits | ? Author -EQ "$(git config --get user.name)" | sort Date -Descending | Out-GridView -Title 'Commits'
}

Export-ModuleMember -Function List-Commits