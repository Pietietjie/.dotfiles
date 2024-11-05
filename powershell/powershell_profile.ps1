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
