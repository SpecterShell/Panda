$Config = @{
    Identifier = 'CometNetwork.BitComet'
    Skip       = $false
}

$Ping = {
    $Uri1 = 'https://update.bitcomet.com/client/bitcomet/'
    $Object1 = Invoke-RestMethod -Uri $Uri1

    $Result = [ordered]@{}

    # Version
    $Result.Version = $Object1.BitComet.AutoUpdate.UpdateGroupList.LatestDownload.file1.'#text'

    # InstallerUrl
    $Result.InstallerUrl = "https://download.bitcomet.com/achive/BitComet_$($Result.Version)_setup.exe"

    return $Result
}

$Pong = {
    param (
        [parameter(Mandatory)]
        $Result
    )

    $Uri2 = 'https://www.bitcomet.com/en/changelog'
    $Object2 = Invoke-WebRequest -Uri $Uri2 | ConvertFrom-Html

    $Uri3 = 'https://www.bitcomet.com/cn/changelog'
    $Object3 = Invoke-WebRequest -Uri $Uri3 | ConvertFrom-Html

    $ReleaseNotesTitle = $Object2.SelectSingleNode('/html/body/div/div/dl/dt[1]').InnerText
    if ($ReleaseNotesTitle.Contains($Result.Version)) {
        # ReleaseTime
        $Result.ReleaseTime = [regex]::Match($ReleaseNotesTitle, '(\d{4}\.\d{1,2}\.\d{1,2})').Groups[1].Value | Get-Date -Format 'yyyy-MM-dd'

        # ReleaseNotes
        $Result.ReleaseNotes = $Object2.SelectNodes('/html/body/div/div/dl/dt[1]/following-sibling::dd[count(.|/html/body/div/div/dl/dt[2]/preceding-sibling::dd)=count(/html/body/div/div/dl/dt[2]/preceding-sibling::dd)]').InnerText | Format-Text | ConvertTo-UnorderedList
    }
    else {
        # ReleaseTime
        $Result.ReleaseTime = $null

        # ReleaseNotes
        $Result.ReleaseNotes = $null
    }

    # ReleaseNotesUrl
    $Result.ReleaseNotesUrl = $Uri2

    if ($Object3.SelectSingleNode('/html/body/div/div/dl/dt[1]').InnerText.Contains($Result.Version)) {
        # ReleaseNotesCN
        $Result.ReleaseNotesCN = $Object3.SelectNodes('/html/body/div/div/dl/dt[1]/following-sibling::dd[count(.|/html/body/div/div/dl/dt[2]/preceding-sibling::dd)=count(/html/body/div/div/dl/dt[2]/preceding-sibling::dd)]').InnerText | Format-Text | ConvertTo-UnorderedList
    }
    else {
        # ReleaseNotesCN
        $Result.ReleaseNotesCN = $null
    }

    # ReleaseNotesUrlCN
    $Result.ReleaseNotesUrlCN = $Uri3
}

return @{
    Config = $Config
    Ping   = $Ping
    Pong   = $Pong
}
