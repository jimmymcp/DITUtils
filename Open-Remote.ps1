function Open-Remote {
    $url = git remote get-url origin
    if (![String]::IsNullOrEmpty($url)) {
        Start-Process $url
    }
}

Export-ModuleMember -Function Open-Remote