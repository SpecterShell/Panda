$Config = @{
    Identifier = 'Wondershare.PDFelement.6.Pro'
    Skip       = $false
}

$Ping = {
    $Result = Invoke-WondershareXmlUpgradeApi -ProductId 2990 -Version '6.0.0.0'

    # InstallerUrl
    $Result.InstallerUrl = 'https://download.wondershare.com/cbs_down/pdfelement6-pro_full2990.exe'

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = 'https://pdf.wondershare.com/whats-new.html'

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    # RealVersion
    $Result.RealVersion = Get-TempFile -Uri $Result.InstallerUrl[0] | Read-ProductVersionFromExe
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}