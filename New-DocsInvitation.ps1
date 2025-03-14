function New-DocsInvitation {
    param(
        [string]$email
    )

    $invitation = az staticwebapp users invite --authentication-provider AAD --domain docs.tes365.com --name TES-IP-Docs --roles "reader" --invitation-expiration-in-hours 168 --user-details $email
    ($invitation | ConvertFrom-Json).invitationUrl | Set-Clipboard
    $invitation
}

Export-ModuleMember -Function New-DocsInvitation