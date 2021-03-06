$Config = @{
    Identifier = 'Wondershare.PDFelement'
    Skip       = $false
}

$Ping = {
    $Result = $script:WondershareUpgradeInfo['5239']

    # InstallerUrl
    $Result.InstallerUrl = @(
        "https://download.wondershare.com/cbs_down/pdfelement-pro_$($Result.Version)_full5239.exe"
        "https://download.wondershare.com/cbs_down/pdfelement-pro_64bit_$($Result.Version)_full5239.exe"
    )

    # ReleaseNotes
    $Result.ReleaseNotes = ($Result.ReleaseNotes | ConvertFrom-Html).SelectNodes('text()').InnerText | Format-Text

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = 'https://pdf.wondershare.com/whats-new.html'

    return $Result
}

return @{
    Config = $Config
    Ping   = $Ping
}
