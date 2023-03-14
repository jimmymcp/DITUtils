function Set-DITUtilsConfig {
    param(
        [string]$KeyName,
        [string]$KeyValue
    )

    $config = Get-DITUtilsConfig
    if ($null -eq $config.$KeyName) {
        $config | Add-Member -MemberType NoteProperty -Name $KeyName -Value $KeyValue
    }
    else {
        $config.$KeyName = $KeyValue
    }

    Set-Content -Path (Get-DITUtilsConfigPath) -Value (ConvertTo-Json $config)
}

Export-ModuleMember -Function Set-DITUtilsConfig