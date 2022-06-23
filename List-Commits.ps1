function List-Commits {
    cd 'C:\Git'
    $Commits = @()
    Get-ChildItem . -Directory | % {
        cd "$_"
        if (Test-Path (Join-Path (Get-Location) '.git')) {
            $Commits += git log --all --format="$($_)~%h~%ai~%s~%an" | ConvertFrom-Csv -Delimiter '~' -Header ('Project,Hash,Date,Message,Author'.Split(','))
        }
        cd ..
    }
    $Commits | ? Author -EQ "$(git config --get user.name)" | sort Date -Descending | Out-GridView -Title 'Commits'
}

Export-ModuleMember -Function List-Commits