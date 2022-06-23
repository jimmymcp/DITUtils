function Test-Permissions {
    $tablesInPermissionSets = @()
  
    $permissionSets = gci . -Recurse -Filter '*.al' | ? {(gc $_.FullName).Item(0).startsWith('permissionset')}
    $permissionSets | % {
      $content = gc $_.FullName -Raw
      [Regex]::Matches($content, '(?<=tabledata ).*(?= =)') | % {
          $tablesInPermissionSets += $_.Value
      }
    }
  
    $tablesInTables = @()
  
    $tables = Get-ChildItem . -Recurse -Filter '*.al' | Where-Object {(Get-Content $_.FullName).Item(0).StartsWith('table ')}
    $tables | % {
      $content = gc $_.FullName -Raw
      [Regex]::Matches($content, "(?<=table \d+ ).*(?=$([Environment]::NewLine))") | % {
          $tablesInTables += $_.Value
      }
    }
  
    $missingTables = ""
  
    Compare-Object $tablesInTables $tablesInPermissionSets | ? SideIndicator -eq '<=' | % {
      $missingTables += $_.InputObject + [Environment]::NewLine
    }
  
    if ('' -ne $missingTables) {
      throw "Missing table permissions: $missingTables"
    }
  }

  Export-ModuleMember -Function Test-Permissions