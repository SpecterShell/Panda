$Config = @{
    Identifier = 'Eassos.DiskGenius'
    Skip       = $false
    Notes      = '国内版'
}

$Ping = {
    $Uri1 = 'https://www.diskgenius.cn/pro/statistics/update.php'
    $Object1 = Invoke-RestMethod -Uri $Uri1 | ConvertFrom-Ini

    $Result = [ordered]@{}

    # Version
    $Result.Version = $Object1.version.new

    # InstallerUrl
    $Result.InstallerUrl = "https://download.eassos.cn/DGSetup$($Result.Version.Replace('.','')).exe"

    # ReleaseNotes
    $Result.ReleaseNotes = $Object1[$Result.Version].releasenote.Split('`|') | Format-Text

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = 'https://www.diskgenius.cn/releasenote.php'

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    $Uri2 = 'https://www.diskgenius.cn/download.php'
    $Object2 = Invoke-WebRequest -Uri $Uri2 | ConvertFrom-Html

    if ($Object2.SelectSingleNode('/html/body/div[3]/div/div[4]/h4/text()').InnerText.Contains($Result.Version)) {
        # ReleaseTime
        $Result.ReleaseTime = [regex]::Match(
            $Object2.SelectSingleNode('/html/body/div[3]/div/div[3]/p').InnerText,
            '(\d{4}-\d{1,2}-\d{1,2})'
        ).Groups[1].Value | Get-Date -Format 'yyyy-MM-dd'
    }
    else {
        # ReleaseTime
        $Result.ReleaseTime = $null
    }
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}
