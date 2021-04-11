#Requires -Version 7

# PowerShell profile script
#   This is my personal PowerShell profile, stored and updated from github
#   across multiple profiles and machines.

# To start using on a new machine, first sync your $PROFILE directory to git with
#   git init
#   git remote add origin https://github.com/jmutchek/PowerShell.git
#   git pull origin main

git -C (join-path $HOME "\Documents\PowerShell\") pull

. $(join-path $HOME "\Documents\PowerShell\" "ProfileFunctions.ps1")

$profile_initialized = $false

function Prompt {

    function Initialize-Profile {
        
        if ((Get-Module PowerLine).Version -lt 3.2) {
            throw "Profile requires PowerLine 3.2+"
        }
        

        # Set up environment for johnny.decimal
        $jd_script = "local\70-code\73-github-personal\johnny.decimal\jd.ps1"
        $jd_testroots = @( "d:\" )

        ForEach ($root in $jd_testroots) {
            If (Test-Path -ErrorAction SilentlyContinue (join-path $root $jd_script)) {
                Write-Host "Setting up jd environment in $root"
                $Env:jd_roots = $root
                new-alias jd (join-path $root $jd_script)
                break
            } 
        }
        $jd_script = $null
        $jd_testroots = $null
        

        # Set up the powerline prompt
        Import-Module PowerLine
        $Prompt = {}
        Add-PowerLineBlock { $MyInvocation.HistoryId }
        Add-PowerLineBlock { "&nbsp;" }
        Add-PowerLineBlock { Get-JDShortenedPath -SingleCharacterSegment }
        # white background
        # Set-PowerLinePrompt -Colors "#ffffff", "#000066" -FullColor -PowerLineFont
        # black background
        Set-PowerLinePrompt -Colors "#000000", "#666699" -FullColor -PowerLineFont
        

        # Set up aliases
        set-alias redo invoke-history
        new-alias z 'D:\local\70-code\73-github-personal\tools\zettelkasten\scripts\z.ps1'


        $profile_initialized = $true
        $Prompt
    }
    
    # most initialization is only required for an interactive session
    if (!$profile_initialized) {
      Initialize-Profile
    }
  
    $currentLastExitCode = $LASTEXITCODE
    $lastSuccess = $?
  
    $global:LASTEXITCODE = $currentLastExitCode
  }
