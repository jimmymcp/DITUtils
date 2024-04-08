function Invoke-AzureDevOpsAPI {
    param(
        [string]$url,
        [string]$pat = (Get-DITUtilsConfig pat),
        [ValidateSet('Get','Post')]
        [string]$method = 'Get',
        $params
    )
    
    if (!($url.StartsWith('https'))) {
        $url = "https://dev.azure.com/$(Get-DITUtilsConfig organisation)/$(Get-DITUtilsConfig project)/_apis/" + $url
    }

    $url += '?api-version=7.1'
    if ($null -ne $params) {
        $params.Keys | ForEach-Object {
            $url += "&$($_)=$($params.$_)"
        }
    }

    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))
    $header = @{authorization = "Basic $token"}

    $result = Invoke-WebRequest -Uri $url -Headers $header -Method $method -ContentType application/json
    $result.content | ConvertFrom-Json
}


Export-ModuleMember -Function .\Invoke-AzureDevOpsAPI