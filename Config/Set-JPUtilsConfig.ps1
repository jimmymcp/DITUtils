function Set-JPUtilsConfig {
    param(
        [string]$KeyName,
        [string]$KeyValue
    )

    $config = Get-JPUtilsConfig
    if ($null -eq $config.$KeyName) {
        $config | Add-Member -MemberType NoteProperty -Name $KeyName -Value $KeyValue
    }
    else {
        $config.$KeyName = $KeyValue
    }

    Set-Content -Path (Get-JPUtilsConfigPath) -Value (ConvertTo-Json $config)
}

Export-ModuleMember -Function Set-JPUtilsConfig