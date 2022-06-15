$Config = @{
    Identifier = 'EdrawSoft.EdrawMind'
    Skip       = $false
}

$Ping = {
    $Result = Invoke-WondershareJsonUpgradeApi -ProductId 5370 -Version '8.0.0' -X86

    # InstallerUrl
    $Result.InstallerUrl = "https://download.edrawsoft.com/cbs_down/edrawmind_$($Result.version)_full5370.exe"

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = 'https://www.edrawsoft.com/whats-new/edrawmind.html'

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    # RealVersion
    $Result.RealVersion = Get-TempFile -Uri $Result.InstallerUrl | Read-ProductVersionFromExe
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}
