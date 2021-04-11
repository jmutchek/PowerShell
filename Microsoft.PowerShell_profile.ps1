#Requires -Version 7

# PowerShell profile script
#   This is my personal PowerShell profile, stored and updated from github
#   across multiple profiles and machines.

# To start using on a new machine, first sync your $PROFILE directory to git with
#   git init -b main
#   git remote add origin https://github.com/jmutchek/PowerShell.git
#   git pull origin main

Write-Host "Using profile https://github.com/jmutchek/PowerShell/commit/$(git -C (join-path $HOME "\Documents\PowerShell\") rev-parse HEAD)"

# Load profile scipt helper functions
. $(join-path $HOME "\Documents\PowerShell\" "ProfileFunctions.ps1")

# Retrieve latest profile script from github (will be used in the next PowerShell session)
git -C (join-path $HOME "\Documents\PowerShell\") pull

# Set up aliases
set-alias redo invoke-history
new-alias z 'D:\local\70-code\73-github-personal\tools\zettelkasten\scripts\z.ps1'

Initialize-JohnnyDecimal @( "d:\" )
Initialize-Prompt
