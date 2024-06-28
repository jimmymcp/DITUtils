function New-DocsInvitation {
    param(
        [string]$email
    )

    az staticwebapp users invite --authentication-provider AAD --domain "docs.tes365.com" --name TES-IP-Docs --roles "reader" --invitation-expiration-in-hours 168 --user-details $email
}

Export-ModuleMember -Function New-DocsInvitation