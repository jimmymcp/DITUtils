function Remove-BranchesWithUpstreamGone {
    (Get-BranchesWithUpstreamGone) | ForEach-Object {
      Write-Host "Removing branch $_"
      git branch $_ -D
    }
  }
  
  function Get-BranchesWithUpstreamGone {
    git fetch --all --prune | Out-Null
    $Branches = git branch -v | Where-Object { $_.Contains('[gone]') }
    $BranchNames += $Branches | ForEach-Object {
      if ($_.Split(' ').Item(1) -ne '') {
        $_.Split(' ').Item(1)
      }
      else {
        $_.Split(' ').Item(2)
      }
    }
  
    $BranchNames
  }

  Export-ModuleMember -Function *