function ConvertFrom-UnixTimeSeconds {
    <#
    .SYNOPSIS
        Convert Unix time in seconds to UTC DateTime
    .PARAMETER Seconds
        The Unix time in seconds
    .OUTPUTS
        datetime
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [long]
        $Seconds
    )

    process {
        [System.DateTimeOffset]::FromUnixTimeSeconds($Seconds).UtcDateTime
    }
}

function ConvertFrom-UnixTimeMilliseconds {
    <#
    .SYNOPSIS
        Convert Unix time in milliseconds to UTC DateTime
    .PARAMETER Milliseconds
        The Unix time in milliseconds
    .OUTPUTS
        datetime
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [long]
        $Milliseconds
    )

    process {
        [System.DateTimeOffset]::FromUnixTimeMilliseconds($Milliseconds).UtcDateTime
    }
}

function ConvertTo-OrderedList {
    <#
    .SYNOPSIS
        Prepend numbers to the string
    .PARAMETER List
        String(s) of the entries
    .OUTPUTS
        string
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [string]
        $List
    )

    begin {
        $Result = @()
        $i = 1
    }

    process {
        $Result += $List -creplace '(?m)^', { "$(($i++)). " }
    }

    end {
        return $Result -join "`n"
    }
}

function ConvertTo-UnorderedList {
    <#
    .SYNOPSIS
        Prepend "- " to the string
    .PARAMETER List
        String(s) of the entries
    .OUTPUTS
        string
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [string]
        $List
    )

    begin {
        $Result = @()
    }

    process {
        $Result += $List -creplace '(?m)^', '- '
    }

    end {
        return $Result -join "`n"
    }
}

function ConvertTo-UtcDateTime {
    <#
    .SYNOPSIS
        Change the DateTime from specified timezone to UTC
    .PARAMETER DateTime
        The DateTime object to be converted
    .PARAMETER Id
        Timezone ID
    .OUTPUTS
        datetime
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [datetime]
        $DateTime,

        [parameter(Mandatory)]
        [string]
        $Id
    )

    process {
        [System.TimeZoneInfo]::ConvertTimeToUtc($DateTime, [System.TimeZoneInfo]::FindSystemTimeZoneById($Id))
    }
}

function Get-RedirectedUrl {
    <#
    .SYNOPSIS
        Get the redirected URL from the given URL
    .OUTPUTS
        string
    #>

    if ($DefaultWebRequestParameters) {
        (Invoke-WebRequest @DefaultWebRequestParameters -Method Head @args).BaseResponse.RequestMessage.RequestUri.AbsoluteUri
    }
    else {
        (Invoke-WebRequest -Method Head @args).BaseResponse.RequestMessage.RequestUri.AbsoluteUri
    }
}

function Get-ResponseContent {
    <#
    .SYNOPSIS
        Get garble-less content from the response object
    .PARAMETER Response
        The response object
    .OUTPUTS
        string
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline)]
        [Microsoft.PowerShell.Commands.WebResponseObject]
        $Response
    )

    process {
        $Stream = $Response.RawContentStream
        $Stream.Position = 0;
        return [System.IO.StreamReader]::new($Stream).ReadToEnd()
    }
}

function Invoke-CustomWebRequest {
    <#
    .SYNOPSIS
        Invoke "Invoke-WebRequest" with custom parameters
    #>

    Invoke-WebRequest @DefaultWebRequestParameters @args
}

function Invoke-CustomRestMethod {
    <#
    .SYNOPSIS
        Invoke "Invoke-RestMethod" with custom parameters
    #>

    Invoke-RestMethod @DefaultWebRequestParameters @args
}

Export-ModuleMember -Function *
