$Config = @{
    'Identifier' = 'Cube.CubePlatform'
    'Skip'       = $false
}

$Fetch = {
    $Uri = 'https://infobox.cubejoy.com/data.ashx?JsonData=%7B%22Code%22:%2210030%22%7D'
    $Object = Invoke-RestMethod -Uri $Uri

    $Result = [ordered]@{}

    # Version
    $Result.Version = $Object.result.version

    # InstallerUrl
    $Result.InstallerUrl = @(
        "https://download.cubejoy.com/app/$($Result.Version)/CubeSetup_v$($Result.Version).exe",
        "https://download.cubejoy.com/app/$($Result.Version)/CubeSetup_HK_TC_v$($Result.Version).exe"
    )

    $ReleaseNotes = $Object.result.whatisnew.Split("`r`n")

    # ReleaseTime
    if ($ReleaseNotes[0] -cmatch '(\d{4}-\d{1,2}-\d{1,2})') {
        $Result.ReleaseTime = Get-Date -Date $Matches[1] -Format 'yyyy-MM-dd'
    }

    # ReleaseNotes
    if ($ReleaseNotes) {
        $Result.ReleaseNotes = $ReleaseNotes[1..($ReleaseNotes.Length - 1)] | Format-Text
    }

    return [PSCustomObject]$Result
}

return [PSCustomObject]@{
    Config = $Config
    Fetch  = $Fetch
}