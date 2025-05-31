# Ensures script fails on errors
$ErrorActionPreference = "Stop"

###############################################################################
# Clone dotfiles
###############################################################################

$clonePath = Read-Host "Where do you want to clone these dotfiles to [~/.dotfiles]?"
if (-not $clonePath) {
    $clonePath = "$env:USERPROFILE\.dotfiles"
}

# Ensure path doesn't exist
while (Test-Path $clonePath) {
    $response = Read-Host "Path exists, try again? (y)"
    if ($response -match "^[Yy]") {
        break
    }
    else {
        Write-Host "Please answer y or CTRL+c the script to abort everything"
    }
}

Write-Host

# Clone the repository
git clone https://github.com/Pietietjie/.dotfiles $clonePath

Set-Location -Path $clonePath


# Initialize and update submodules
git submodule init
git submodule update

# Set the git remote
git remote remove origin
git remote add origin git@github.com:Pietietjie/.dotfiles.git

.\install.ps1

Write-Host "Everything was installed successfully!"
Write-Host "`nYou can safely close this PowerShell window."
Write-Host "The next time you open your terminal, your environment will be ready to go!"
exit 0

