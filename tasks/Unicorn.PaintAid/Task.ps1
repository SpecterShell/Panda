$Config = @{
    Identifier = 'Unicorn.PaintAid'
    Skip       = $false
}

$Ping = {
    $Uri = 'http://pa.udongman.cn/index.php/upgrade/'
    $Object = Invoke-RestMethod -Uri $Uri

    $Result = [ordered]@{}

    # Version
    $Result.Version = $Object.updater.mversion + '.' + $Object.updater.subversion

    # InstallerUrl
    $Result.InstallerUrl = $Object.updater.TypeWin.package_url + $Object.updater.TypeWin.package.name

    # ReleaseTime
    if ($Object.updater.TypeWin.package.name -cmatch '(\d{8})') {
        $Result.ReleaseTime = [datetime]::ParseExact($Matches[1], 'yyyyMMdd', $null).ToString('yyyy-MM-dd')
    }

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    $Uri2 = "http://pa.udongman.cn/index.php/v2/version/detail?version=$($Result.Version)"
    $Object2 = Invoke-RestMethod -Uri $Uri2

    # ReleaseNotes
    $Result.ReleaseNotes = $Object2.data.data.func_description | Format-Text
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}