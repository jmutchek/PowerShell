# Set up the local config params based on current user and machine
function Get-LocalConfig {
    $localConfig = @{
        jd_roots= @();
        code_root= ''
    }

    switch ($env:USERNAME) {
        "john5"     { $localConfig.jd_roots += "d:\" }
        "jmutchek"  { $localConfig.jd_roots += "c:\Users\jmutchek\OneDrive - Microsoft" }
        Default     {}
    } 

    if (Test-Path d:) {
        $localConfig.code_root = "d:\local\70-code"
    } else {
        $localConfig.code_root = "c:\local\70-code"
    }
    
    return $localConfig
}

# Set up environment for johnny.decimal
function Initialize-JohnnyDecimal($roots) {
    $jd_script = "local\70-code\73-github-personal\johnny.decimal\jd.ps1"
    $jd_testroots = $roots
    ForEach ($root in $jd_testroots) {
        If (Test-Path -ErrorAction SilentlyContinue (join-path $root $jd_script)) {
            Write-Host "Setting up jd environment in $root"
            $Env:jd_roots = $root
            new-alias jd (join-path $root $jd_script) -Scope Global
            break
        } 
    }
    $jd_script = $null
    $jd_testroots = $null

}

function Get-JDShortenedPath {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]
        $Path = $pwd,

        [Parameter()]
        [switch]
        $RelativeToHome,

        [Parameter()]
        [int]
        $MaximumLength = [int]::MaxValue,

        [Parameter()]
        [switch]
        $SingleCharacterSegment        
    )

    if ($MaximumLength -le 0) {
        return [string]::Empty
    }

    if ($RelativeToHome -and $Path.ToLower().StartsWith($Home.ToLower())) {
        $Path = '~' + $Path.Substring($Home.Length)
    }

    if (($MaximumLength -gt 0) -and ($Path.Length -gt $MaximumLength)) {
        $Path = $Path.Substring($Path.Length - $MaximumLength)
        if ($Path.Length -gt 3) {
            $Path = "..." + $Path.Substring(3)
        }
    }

    # Credit: http://www.winterdom.com/powershell/2008/08/13/mypowershellprompt.html
    if ($SingleCharacterSegment) {
        # Remove prefix for UNC paths
        $Path = $Path -replace '^[^:]+::', ''
        # handle paths starting with \\ and . correctly
        $Path = ($Path -replace '\\(\.?)([^\\]\d?)[^\\]*(?=\\)','\$1$2')
    }

    $Path
}

# Set up the powerline prompt
function Initialize-Prompt() {
    Import-Module PowerLine
    if ((Get-Module PowerLine).Version -lt 3.2) {
        throw "Profile requires PowerLine 3.2+"
    }

    $Prompt = {}
    Add-PowerLineBlock { $MyInvocation.HistoryId }
    Add-PowerLineBlock { "&nbsp;" }
    Add-PowerLineBlock { Get-JDShortenedPath -SingleCharacterSegment }
    # white background
    # Set-PowerLinePrompt -Colors "#ffffff", "#000066" -FullColor -PowerLineFont
    # black background
    Set-PowerLinePrompt -Colors "#000000", "#666699" -FullColor -PowerLineFont   
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