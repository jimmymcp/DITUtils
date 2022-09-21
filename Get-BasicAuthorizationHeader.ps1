function Get-BasicAuthorizationHeader {
    param(
        [Parameter(Position = 1)]
        [string]$UserName,
        [Parameter(Position = 2)]
        [string]$Password
    )

    $bytes = [System.Text.Encoding]::ASCII.GetBytes("$($UserName):$($Password)")
    $base64 = [Convert]::ToBase64String($bytes)

    @{"Authorization" = "Basic $base64" }
}

Export-ModuleMember -Function Get-BasicAuthorizationHeader