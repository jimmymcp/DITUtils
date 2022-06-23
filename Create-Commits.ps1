function Create-Commits {
    param(
        [string]$CommitMessages
    )

    foreach ($Message in ($CommitMessages.Split(','))) {
        $Path = Join-Path . ("$([Guid]::NewGuid()).txt")
        Set-Content -Path $Path -Value $Message
        git add -A
        git commit -m "$Message"
    }
}

Export-ModuleMember -Function Create-Commits