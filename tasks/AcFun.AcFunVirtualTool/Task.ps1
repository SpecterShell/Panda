$Config = @{
    Identifier = 'AcFun.AcFunVirtualTool'
    Skip       = $false
}

$Ping = {
    $Uri = 'https://api.kuaishouzt.com/rest/zt/appsupport/checkupgrade?appver=0.0.0.0&kpn=ACFUN_APP.LIVE.PC&kpf=WINDOWS_PC'
    $Object = Invoke-RestMethod -Uri $Uri

    $Result = [ordered]@{}

    # Version
    $Result.Version = $Object.releaseInfo.version

    # InstallerUrl
    $Result.InstallerUrl = $Object.releaseInfo.downloadUrl

    # ReleaseNotes
    $Result.ReleaseNotes = $Object.releaseInfo.message | Format-Text

    return $Result
}

return @{
    Config = $Config
    Ping   = $Ping
}
