Set-Alias -Name g -Value git
# 1 Character Aliases
set-alias -Name a -Value artisan
set-alias -Name d -Value docker
set-alias -Name g -Value git
set-alias -Name p -Value php
# Remaining Aliases
set-alias -Name so -Value refreshenv
remove-item -Force Alias:nv
set-alias -Name nv -Value nvim
set-alias -Name cl -Value clear

function .. {
    Invoke-command -ScriptBlock {cd ..}
}
function ... {
    Invoke-command -ScriptBlock {cd ../..}
}
function .... {
    Invoke-command -ScriptBlock {cd ../../..}
}
function ..... {
    Invoke-command -ScriptBlock {cd ../../../..}
}
function q {
    Invoke-command -ScriptBlock {exit}
}
function :q {
    Invoke-command -ScriptBlock {exit}
}
## allows the use of choco utilities
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
## adds bash like unix commands instead of the useless windows ones
Set-PSReadLineOption -EditMode Emacs

function prompt {
    # #Assign Windows Title Text
    # $host.ui.RawUI.WindowTitle = "Current Folder: $pwd"

    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format ' HH:mm:ss'
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    if (Get-Error) {
        Write-Host "󰻌  " -ForegroundColor Red -NoNewline
    } else {
        Write-Host "󰳉  " -ForegroundColor Green -NoNewline
    }
    if ($IsAdmin) {
        Write-host '🪟   ' -ForegroundColor Red -NoNewline
    } else { 
        Write-host '🪟  ' -ForegroundColor Blue -NoNewline
    }
    Write-Host "$($CmdPromptUser.Name.split("\")[1])@$($CmdPromptUser.Name.split("\")[0])" -ForegroundColor Blue -NoNewline
    Write-Host ":"  -ForegroundColor Yellow -NoNewline
    Write-Host "$pwd"  -ForegroundColor Green -NoNewline

    Write-Host " ‹󰨊 $((Get-Host).Version.ToString())›" -ForegroundColor Magenta -NoNewline
    Write-Host " $date" -ForegroundColor Red
    if (Get-Error) {
        Write-Host "╰─" -NoNewline -ForegroundColor Red
    } else {
        Write-Host "╰─" -NoNewline -ForegroundColor Green
    }
    Write-Host " " -NoNewline -ForegroundColor Magenta
    if (git branch) {
        Write-Host "  $(git rev-parse --abbrev-ref HEAD) " -NoNewline -ForegroundColor Magenta
        if (git status -s) {
            Write-Host "  " -NoNewline -ForegroundColor Yellow
        }
    } else {
        Write-Host "   " -NoNewline -ForegroundColor Red
    }
    Write-Host ":" -NoNewline -ForegroundColor Magenta
    return " "
} #end prompt function
Clear-Host
