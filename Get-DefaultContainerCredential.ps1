function Get-DefaultContainerCredential {
    $userName = Get-DITUtilsConfig -Key 'defaultContainerCredentialUserName'
    $password = Get-DITUtilsConfig -Key 'defaultContainerCredentialPassword'
    [pscredential]::new($userName, (ConvertTo-SecureString $password -AsPlainText -Force))
}

Export-ModuleMember -Function Get-DefaultContainerCredential