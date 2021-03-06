$Config = @{
    Identifier = '360.360Zip'
    Skip       = $false
}

$Ping = {
    $Uri1 = 'https://www.360totalsecurity.com/en/360zip/'
    $Object1 = Invoke-WebRequest -Uri $Uri1 | ConvertFrom-Html

    $Uri2 = 'https://www.360totalsecurity.com/en/download-free-360-zip/'
    $Object2 = Invoke-WebRequest -Uri $Uri2 | ConvertFrom-Html

    $Result = [ordered]@{}

    # Version
    $Result.Version = [regex]::Match(
        $Object1.SelectSingleNode('//*[@id="primary-actions"]/p/span').InnerText,
        '([\d\.]+)'
    ).Groups[1].Value

    # InstallerUrl
    $Result.InstallerUrl = 'https:' + $Object2.SelectSingleNode('//*[@id="download-intro"]/div[1]/a').Attributes['href'].Value

    return $Result
}

return @{
    Config = $Config
    Ping   = $Ping
}
