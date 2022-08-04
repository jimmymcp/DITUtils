function Get-FileList() {
    param($path)

    $files = @()
    Get-ChildItem $path -Filter *.app | % { $files += $_.FullName }
    $files
}

function Get-LatestPublishedVersion {
    param(
        [string]$ServerInstance,
        [string]$Publisher,
        [string]$AppName,
        [string]$Tenant = 'default'
    )

    Get-NavAppInfo -ServerInstance $ServerInstance -Publisher $Publisher -Name $AppName -TenantSpecificProperties -TenantId $Tenant | sort Version -Descending | select -First 1
}

function Publish-App {
    param(
        [string]$ServerInstance,
        [string]$Path,
        $AppInfo
    )

    "Publishing $Path on $ServerInstance"
    Publish-NavApp -ServerInstance $ServerInstance -Path $Path -SkipVerification
}

function Sync-App {
    param(
        [string]$ServerInstance,
        [string]$Path,
        $AppInfo,
        [string]$Tenant
    )

    "Syncing $($AppInfo.Publisher) $($AppInfo.Name) $($AppInfo.Version) on $ServerInstance"
    Sync-NavApp -ServerInstance $ServerInstance -Publisher $AppInfo.Publisher -Name $AppInfo.Name -Version $AppInfo.Version -Tenant $Tenant
}

function PublishAndInstall-App {
    param(
        [string]$ServerInstance,
        [string]$Path,
        $AppInfo,
        [string]$Tenant
    )

    Publish-App -ServerInstance $ServerInstance -Path $Path -AppInfo $AppInfo
    Sync-App -ServerInstance $ServerInstance -Path $Path -AppInfo $AppInfo -Tenant $Tenant

    "Installing $($AppInfo.Publisher) $($AppInfo.Name) $($AppInfo.Version) on $ServerInstance"
    Install-NavApp -ServerInstance $ServerInstance -Publisher $AppInfo.Publisher -Name $AppInfo.Name -Version $AppInfo.Version -Tenant $Tenant -Force
}

function Upgrade-App {
    param(
        [string]$ServerInstance,
        [string]$Path,
        $AppInfo,
        [string]$Tenant,
        $LatestPublishedVersion
    )
    if ($LatestPublishedVersion.IsInstalled) {
        "Uninstalling $($LatestPublishedVersion.Publisher) $($LatestPublishedVersion.Name) $($LatestPublishedVersion.Version)"
        Uninstall-NavApp -ServerInstance $ServerInstance -Publisher $LatestPublishedVersion.Publisher -Name $LatestPublishedVersion.Name -Version $LatestPublishedVersion.Version -Force
    }

    Publish-App -ServerInstance $ServerInstance -Path $Path -AppInfo $AppInfo
    Sync-App -ServerInstance $ServerInstance -Path $Path -AppInfo $AppInfo -Tenant $Tenant

    "Upgrading data for $($AppInfo.Publisher) $($AppInfo.Name) $($AppInfo.Version) on $ServerInstance"
    Start-NavAppDataUpgrade -ServerInstance $ServerInstance -Publisher $AppInfo.Publisher -Name $AppInfo.Name -Version $AppInfo.Version -Tenant $Tenant

    "Unpublishing $($LatestPublishedVersion.Publisher) $($LatestPublishedVersion.Name) $($LatestPublishedVersion.Version) on $ServerInstance"
    Unpublish-NavApp -ServerInstance $ServerInstance -Publisher $LatestPublishedVersion.Publisher -Name $LatestPublishedVersion.Name -Version $LatestPublishedVersion.Version
}

function UpgradeOrInstall-Apps {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ServerInstance,
        [Parameter(Mandatory = $true)]
        [string]$SourceFolder,
        [Parameter(Mandatory = $false)]
        [string]$Tenant = 'default'
    )
    $apps = Get-FileList $SourceFolder

    $apps | ForEach-Object {
        "App file: $_"
        $AppInfo = Get-NavAppInfo -Path $_
        $LatestPublishedVersion = Get-LatestPublishedversion -ServerInstance $ServerInstance -Publisher $AppInfo.Publisher -AppName $AppInfo.Name -Tenant $Tenant

        if ($null -eq $LatestPublishedVersion) {
            "No previous version found, installing..."
            PublishAndInstall-App -ServerInstance $ServerInstance -Path $_ -AppInfo $AppInfo -Tenant $Tenant
        }
        else {
            if ($LatestPublishedVersion.Version -eq $AppInfo.Version) {
                "Version $($LatestPublishedVersion.Version) already installed, skipping..."
            }
            else {
                "Version $($LatestPublishedVersion.Version) already published, upgrading..."
                Upgrade-App -ServerInstance $ServerInstance -Path $_ -AppInfo $AppInfo -Tenant $Tenant -LatestPublishedVersion $LatestPublishedVersion
            }
        }
    }
}

UpgradeOrInstall-Apps $args[0] $args[1]