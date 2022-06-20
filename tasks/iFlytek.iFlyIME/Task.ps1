$Config = @{
    Identifier = 'iFlytek.iFlyIME'
    Skip       = $false
}

$Ping = {
    $Uri = 'https://godbiao.com/api/getv/'
    $Headers = @{
        origin = 'https://srf.xunfei.cn'
    }
    $Object = Invoke-RestMethod -Uri $Uri -Headers $Headers

    $Result = [ordered]@{}

    # Version
    $Result.Version = [regex]::Match($Object[2], 'v([\d\.]+)').Groups[1].Value

    # InstallerUrl
    $Result.InstallerUrl = Get-RedirectedUrl -Uri 'https://srf.xunfei.cn/winpc/'

    return $Result
}

return @{
    Config = $Config
    Ping   = $Ping
}