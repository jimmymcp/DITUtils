function Create-PullRequest {
    $url = git remote get-url origin
    $sourceRef = git rev-parse --abbrev-ref HEAD

    if ($sourceRef.StartsWith('release')) {
        $targetRef = 'main'
    }
    else {
        $targetRef = Get-ReleaseBranchName
    }

    Write-Host "Creating pull request from $sourceRef to $targetRef"

    $url = "$url/pullrequestcreate?sourceRef=$sourceRef&targetRef=$targetRef"
    Start-Process $url
}

Export-ModuleMember -Function Create-PullRequest