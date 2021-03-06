$Config = @{
    Identifier = 'Coldlake.StellarPlayer'
    Skip       = $false
    Notes      = @'
更新源 64 位
https://www.stellarplayer.com/blog/category/post/changelog
'@
}

$Ping = {
    $Uri1 = 'https://ab.coldlake1.com/v1/abt/matcher?arch=x64'
    $Object1 = Invoke-RestMethod -Uri $Uri1

    $Result = [ordered]@{}

    # Version
    $Result.Version = [regex]::Match($Object1.data, '(\d{14})').Groups[1].Value

    # InstallerUrl
    $Result.InstallerUrl = "https://player-download.coldlake1.com/player/$($Result.Version)/Stellar_$($($Result.Version))_official_stable_full_x64.exe"

    # ReleaseTime
    $Result.ReleaseTime = [datetime]::ParseExact($Result.Version, 'yyyyMMddHHmmss', $null) | ConvertTo-UtcDateTime -Id 'China Standard Time'

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    $Uri2 = "https://player-update.coldlake1.com/version/gray/$($Result.Version)_x64.ini"
    $Object2 = Invoke-WebRequest -Uri $Uri2 | Read-ResponseContent | ConvertFrom-Ini

    # ReleaseNotes
    $Result.ReleaseNotes = $Object2.update.info | Format-Text

    # RealVersion
    $Result.RealVersion = Get-TempFile -Uri $Result.InstallerUrl | Read-ProductVersionFromExe
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}
