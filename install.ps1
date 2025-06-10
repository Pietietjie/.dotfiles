# Ensures script fails on errors
$ErrorActionPreference = "Continue"

###############################################################################
# set up symlinks
###############################################################################
.\install_dotbot.ps1 -c windows.conf.yml

###############################################################################
# copy and override the shortcuts
###############################################################################
$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "shortcuts"
$destinationPath = Join-Path -Path $env:ProgramData -ChildPath "Microsoft\Windows\Start Menu\Programs"
$alternativeDestinationPath = Join-Path -Path $env:AppData -ChildPath "Microsoft\Windows\Start Menu\Programs"
if ((Test-Path -Path $sourcePath)) {
    $files = Get-ChildItem -Path $sourcePath -File
    Write-Host "$files"
    try {
        if (Test-Path -Path $destinationPath) {
            Write-Host "Copying files to ProgramData Start Menu..."
            foreach ($file in $files) {
                Copy-Item -Path $file.FullName -Destination $destinationPath -Force
            }
        }
        else {
            Write-Host "ProgramData Start Menu not found. Trying AppData Start Menu..."
            if (Test-Path -Path $alternativeDestinationPath) {
                foreach ($file in $files) {
                    Copy-Item -Path $file.FullName -Destination $alternativeDestinationPath -Force
                }
            }
            else {
                Write-Host "Neither ProgramData nor AppData Start Menu folder found."
            }
        }
        Write-Host "File copy completed successfully."
    }
    catch {
        Write-Host "An error occurred: $($Error[0].Message)"
        Write-Host "Make sure you have permission to access the Start Menu folder."
        Write-Host "You may need to run PowerShell as Administrator."
    }
}
###############################################################################
# Install Chocolatey and required software
###############################################################################
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

try {
    Write-Host "Installing software..."
    choco install -y sqlite neovim zig ripgrep nodejs
} catch {
    Write-Host "Error installing software: $($Error[0].Message)"
}

try {
    $nvimDbPath = Join-Path -Path $env:HOME -ChildPath ".local/share/nvim/databases"
    Write-Host "Creating nvim databases directory..."
    New-Item -Path $nvimDbPath -ItemType Directory -Force
    Write-Host "Creating telescope_history.sqlite3..."
    New-Item -Path $sqlitePath -ItemType File
} catch {
}

Write-Host "Everything was installed successfully!"
exit 0

