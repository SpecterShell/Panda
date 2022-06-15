$Config = @{
    Identifier = 'Wondershare.Anireel'
    Skip       = $false
}

$Ping = {
    $Result = Invoke-WondershareJsonUpgradeApi -ProductId 9589 -Version '1.0.0.0'

    # InstallerUrl
    $Result.InstallerUrl = "https://download.wondershare.com/cbs_down/anireel_64bit_$($Result.Version)_full9589.exe"

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = 'https://anireel.wondershare.com/whats-new.html'

    return $Result
}

return @{
    Config = $Config
    Ping   = $Ping
}