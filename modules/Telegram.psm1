# Telegram Bot token
$TGBotToken = $env:TG_BOT_TOKEN
# Telegram Chat ID
$TGChatID = $env:TG_CHAT_ID

# Apply default parameters for most web requests if exists
if ($DefaultWebRequestParameters) {
    $PSDefaultParameterValues = $DefaultWebRequestParameters
}

filter Send-TelegramMessage {
    <#
    .SYNOPSIS
        Function to send message using Telegram Bot API
    .OUTPUTS
        pscustomobject
    #>

    # Avoid conflicts
    $Session = $_

    if (-not ($TGBotToken -and $TGChatID)) {
        Write-Error -Message 'Either Telegram Bot token or Telegram Chat ID is not given, skip sending' -CategoryActivity 'Panda'
        return $Session
    }

    $Message = Invoke-Command -ScriptBlock $Session.Template -ArgumentList $Session
    $Payload = @{
        chat_id = $TGChatID
        text    = $Message
    }
    $Request = @{
        Uri         = "https://api.telegram.org/bot$($TGBotToken)/sendMessage"
        Method      = 'Post'
        Body        = ([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject $payload -Compress)))
        ContentType = 'application/json'
    }

    Invoke-RestMethod @Request | Out-Null

    return $Session
}

Export-ModuleMember -Function Send-TelegramMessage
