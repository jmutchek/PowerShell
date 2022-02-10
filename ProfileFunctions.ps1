# Set up the powerline prompt
# https://github.com/Jaykul/PowerLine
function Initialize-Prompt() {
    Write-Output "Initializing prompt..."

    Import-Module PowerLine
    if ((Get-Module PowerLine).Version -lt 3.2) {
        throw "Profile requires PowerLine 3.2+"
    }

    $global:Prompt = @(
        { $MyInvocation.HistoryId }
        { "&nbsp;" }
        { Get-ShortenedPath }
    )
    # black background
    Set-PowerLinePrompt -Colors "#000000", "#666699" -FullColor -PowerLineFont   

    # white background
    # Set-PowerLinePrompt -Colors "#ffffff", "#000066" -FullColor -PowerLineFont
}

# Function to set the title of the window
function Set-Title {
    param(
        [string]
        $title
    )
    $Host.UI.RawUI.WindowTitle = $title   
}

# Set up function for 1Password password lookup using jq
if (get-command -ErrorAction SilentlyContinue op) {
    function 1p {op get item $args | jq .details.fields}
}