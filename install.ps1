#Requires -Version 5.1

# Ensures script fails on errors and provides better error handling
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Function to write colored output
function Write-Status
{
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    switch ($Type)
    {
        "Success"
        { Write-Host $Message -ForegroundColor Green
        }
        "Warning"
        { Write-Host $Message -ForegroundColor Yellow
        }
        "Error"
        { Write-Host $Message -ForegroundColor Red
        }
        default
        { Write-Host $Message -ForegroundColor Cyan
        }
    }
}

# Function to test admin privileges
function Test-Administrator
{
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

###############################################################################
# Copy and override the shortcuts
###############################################################################
function Install-Shortcuts
{
    Write-Status "Installing shortcuts..." "Info"

    $sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "shortcuts"
    $destinations = @(
        (Join-Path -Path $env:ProgramData -ChildPath "Microsoft\Windows\Start Menu\Programs"),
        (Join-Path -Path $env:AppData -ChildPath "Microsoft\Windows\Start Menu\Programs")
    )

    if (-not (Test-Path -Path $sourcePath))
    {
        Write-Status "Shortcuts folder not found at: $sourcePath" "Warning"
        return
    }

    $files = Get-ChildItem -Path $sourcePath -File -Filter "*.lnk"
    if ($files.Count -eq 0)
    {
        Write-Status "No shortcut files found in: $sourcePath" "Warning"
        return
    }

    Write-Status "Found $($files.Count) shortcut(s) to install" "Info"

    $installed = $false
    foreach ($destination in $destinations)
    {
        if (Test-Path -Path $destination)
        {
            try
            {
                Write-Status "Copying shortcuts to: $destination" "Info"
                foreach ($file in $files)
                {
                    Copy-Item -Path $file.FullName -Destination $destination -Force
                    Write-Status "  Copied: $($file.Name)" "Success"
                }
                $installed = $true
                break
            } catch
            {
                Write-Status "Failed to copy to $destination`: $($_.Exception.Message)" "Error"
            }
        }
    }

    if (-not $installed)
    {
        Write-Status "Could not install shortcuts to any Start Menu location" "Error"
        if (-not (Test-Administrator))
        {
            Write-Status "Try running as Administrator for system-wide installation" "Warning"
        }
    }
}

###############################################################################
# Install Chocolatey and required software
###############################################################################
function Install-Chocolatey
{
    if (Get-Command choco -ErrorAction SilentlyContinue)
    {
        Write-Status "Chocolatey already installed" "Success"
        return
    }

    Write-Status "Installing Chocolatey..." "Info"
    try
    {
        Set-ExecutionPolicy RemoteSigned -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Status "Chocolatey installed successfully" "Success"
    } catch
    {
        Write-Status "Failed to install Chocolatey: $($_.Exception.Message)" "Error"
        throw
    }
}

function Install-Software
{
    Write-Status "Installing software packages..." "Info"

    $packages = @(
        @{ Name = "sqlite"; Version = $null },
        @{ Name = "zig"; Version = $null },
        @{ Name = "ripgrep"; Version = $null },
        @{ Name = "nodejs"; Version = $null },
        @{ Name = "googlechrome"; Version = $null },
        @{ Name = "firefox"; Version = $null },
        @{ Name = "discord"; Version = $null },
        @{ Name = "docker-desktop"; Version = $null },
        @{ Name = "malwarebytes"; Version = $null },
        @{ Name = "libreoffice-fresh"; Version = $null },
        @{ Name = "keepassxc"; Version = $null },
        @{ Name = "dbeaver"; Version = $null },
        @{ Name = "postman"; Version = $null },
        @{ Name = "neovim"; Version = "0.10.3" },
        @{ Name = "alacritty"; Version = "0.15.1" },
        @{ Name = "wezterm"; Version = "20240203.110809.0" },
        @{ Name = "python"; Version = "3.13.4" }
    )

    $failed = @()
    foreach ($package in $packages)
    {
        try
        {
            $installCmd = "choco install -y $($package.Name)"
            if ($package.Version)
            {
                $installCmd += " --version=$($package.Version)"
            }

            Write-Status "Installing $($package.Name)..." "Info"
            Invoke-Expression $installCmd
            Write-Status "  $($package.Name) installed successfully" "Success"
        } catch
        {
            Write-Status "  Failed to install $($package.Name): $($_.Exception.Message)" "Error"
            $failed += $package.Name
        }
    }

    if ($failed.Count -gt 0)
    {
        Write-Status "Failed to install: $($failed -join ', ')" "Warning"
    }

    try
    {
        refreshenv
        Write-Status "Environment refreshed" "Success"
    } catch
    {
        Write-Status "Failed to refresh environment: $($_.Exception.Message)" "Warning"
    }
}

###############################################################################
# Set up symlinks
###############################################################################
function Install-Dotfiles
{
    Write-Status "Setting up dotfiles..." "Info"

    $dotbotScript = Join-Path -Path $PSScriptRoot -ChildPath "install_dotbot.ps1"
    $configFile = Join-Path -Path $PSScriptRoot -ChildPath "windows.conf.yml"

    if (-not (Test-Path -Path $dotbotScript))
    {
        Write-Status "Dotbot script not found: $dotbotScript" "Warning"
        return
    }

    if (-not (Test-Path -Path $configFile))
    {
        Write-Status "Config file not found: $configFile" "Warning"
        return
    }

    try
    {
        & $dotbotScript -c $configFile
        Write-Status "Dotfiles configured successfully" "Success"
    } catch
    {
        Write-Status "Failed to configure dotfiles: $($_.Exception.Message)" "Error"
    }
}

function Setup-NvimDirectories
{
    Write-Status "Setting up Neovim directories..." "Info"

    try
    {
        $nvimDbPath = Join-Path -Path $env:HOME -ChildPath ".local/share/nvim/databases"
        $sqlitePath = Join-Path -Path $nvimDbPath -ChildPath "telescope_history.sqlite3"

        if (-not (Test-Path -Path $nvimDbPath))
        {
            New-Item -Path $nvimDbPath -ItemType Directory -Force | Out-Null
            Write-Status "Created nvim databases directory" "Success"
        }

        if (-not (Test-Path -Path $sqlitePath))
        {
            New-Item -Path $sqlitePath -ItemType File -Force | Out-Null
            Write-Status "Created telescope_history.sqlite3" "Success"
        }
    } catch
    {
        Write-Status "Failed to setup Neovim directories: $($_.Exception.Message)" "Warning"
    }
}

###############################################################################
# Main execution
###############################################################################
function Main
{
    Write-Status "Starting installation process..." "Info"
    Write-Status "PowerShell Version: $($PSVersionTable.PSVersion)" "Info"
    Write-Status "Running as Administrator: $(Test-Administrator)" "Info"

    try
    {
        Install-Shortcuts
        Install-Chocolatey
        Install-Software
        Install-Dotfiles
        Setup-NvimDirectories

        Write-Status "Installation completed successfully!" "Success"
        Write-Status "You may need to restart your terminal or computer for all changes to take effect." "Info"
    } catch
    {
        Write-Status "Installation failed: $($_.Exception.Message)" "Error"
        exit 1
    }
}

# Run main function
Main
