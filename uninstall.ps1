# Ensures script fails on errors
$ErrorActionPreference = "Continue"

Write-Host "Starting uninstall process..."

###############################################################################
# Remove shortcuts
###############################################################################
$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "shortcuts"
$destinationPath = Join-Path -Path $env:ProgramData -ChildPath "Microsoft\Windows\Start Menu\Programs"
$alternativeDestinationPath = Join-Path -Path $env:AppData -ChildPath "Microsoft\Windows\Start Menu\Programs"

if (Test-Path -Path $sourcePath) {
    $files = Get-ChildItem -Path $sourcePath -File
    Write-Host "Removing shortcuts..."

    try {
        foreach ($file in $files) {
            $primaryTarget = Join-Path -Path $destinationPath -ChildPath $file.Name
            $alternativeTarget = Join-Path -Path $alternativeDestinationPath -ChildPath $file.Name

            if (Test-Path -Path $primaryTarget) {
                Remove-Item -Path $primaryTarget -Force
                Write-Host "Removed: $primaryTarget"
            }

            if (Test-Path -Path $alternativeTarget) {
                Remove-Item -Path $alternativeTarget -Force
                Write-Host "Removed: $alternativeTarget"
            }
        }
        Write-Host "Shortcuts removal completed successfully."
    }
    catch {
        Write-Host "An error occurred removing shortcuts: $($Error[0].Message)"
    }
}

###############################################################################
# Uninstall software via Chocolatey
###############################################################################
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Uninstalling software..."

    try {
        $packages = @(
            "sqlite", "zig", "ripgrep", "nodejs", "googlechrome",
            "firefox", "discord", "docker-desktop", "malwarebytes",
            "libreoffice-fresh", "keepassxc", "dbeaver", "neovim",
            "alacritty", "wezterm", "python"
        )

        foreach ($package in $packages) {
            Write-Host "Uninstalling $package..."
            choco uninstall -y $package
        }

        refreshenv
        Write-Host "Software uninstallation completed."
    }
    catch {
        Write-Host "Error uninstalling software: $($Error[0].Message)"
    }

    # Optional: Remove Chocolatey itself
    $removeChoco = Read-Host "Do you want to remove Chocolatey as well? (y/N)"
    if ($removeChoco -eq "y" -or $removeChoco -eq "Y") {
        Write-Host "Removing Chocolatey..."
        try {
            Remove-Item -Path $env:ChocolateyInstall -Recurse -Force -ErrorAction SilentlyContinue
            [Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, "User")
            [Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, "Machine")
            Write-Host "Chocolatey removed successfully."
        }
        catch {
            Write-Host "Error removing Chocolatey: $($Error[0].Message)"
        }
    }
}
else {
    Write-Host "Chocolatey not found, skipping software uninstallation."
}

# ###############################################################################
# # Remove symlinks (run dotbot cleanup if available)
# ###############################################################################
# if (Test-Path -Path ".\install_dotbot.ps1") {
#     Write-Host "Running dotbot cleanup..."
#     try {
#         # Note: This assumes dotbot has a cleanup option or you have a separate cleanup script
#         # You may need to modify this based on your dotbot configuration
#         Write-Host "Manual cleanup of dotbot symlinks may be required."
#         Write-Host "Check your windows.conf.yml for symlinked files and remove them manually."
#     }
#     catch {
#         Write-Host "Error running dotbot cleanup: $($Error[0].Message)"
#     }
# }
#
###############################################################################
# Remove nvim databases directory
###############################################################################
try {
    $nvimDbPath = Join-Path -Path $env:HOME -ChildPath ".local/share/nvim/databases"
    if (Test-Path -Path $nvimDbPath) {
        Write-Host "Removing nvim databases directory..."
        Remove-Item -Path $nvimDbPath -Recurse -Force
        Write-Host "Nvim databases directory removed."
    }
}
catch {
    Write-Host "Error removing nvim databases: $($Error[0].Message)"
}

Write-Host "Uninstall process completed!"
Write-Host "Note: Some manual cleanup may be required for:"
Write-Host "- Dotbot symlinks (check windows.conf.yml)"
Write-Host "- User data and configurations"
Write-Host "- Registry entries from installed software"

exit 0
