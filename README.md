# .dotfiles

My personal dotfile config 🔫(◔◡◔)🤏

## Install
### Bootstrap Linux
```bash
bash <(curl -sS https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap)
```

### Bootstrap Windows
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap" -OutFile "$env:TEMP\bootstrap.ps1"
& "$env:TEMP\bootstrap.ps1"
```

### Manual
```bash
git submodule init && git submodule update
sudo ./install
```

#### Troubleshooting/Tips/Common issues
- If nvim complains and says "nvim no parser for 'markdown' language" run `:TSInstall markdown markdown_inline`
- On windows WSL 2 when hosting docker containers sometimes you need to kill apache to allow the access the containers in chromium browsers `sudo service apache2 stop` || `sudo systemctl stop apache2`
## TODO
- NVIM:
    - NB! NB! look at improving the error management I cannot have a text editor that screams and cries all the time if there is something wrong with the enviroment I should still be able to see if there is anything that breaks but it should require a special binding to interact with and should be non invasive
    - look at making that the telescope preview is disabled to buffers that is minified
    - make that the selection that is used for the telescope 🔭 grep search is escaped
    - fix emojis breaking the spacing
        - caused by LSP, snippets, tokyo night theme, & vim.opt.termguicolors = true
    - look into polyglot
    - [refactor plugin](https://github.com/ThePrimeagen/refactoring.nvim)
    - [trouble plugin](https://github.com/folke/trouble.nvim)
    - Look at getting a [ debugger for nvim ](https://github.com/mfussenegger/nvim-dap)
    - Look creating functionality that allow Telescope buffer fuzzy finder to close buffers
- Look at implementing the [windows dotbot plugin](https://github.com/kurtmckee/dotbot-windows)
- Look at a better way to add long paths when writing commands like `cp` and `mv`
- System preferences/settings
## 🌱 Inspiration 🌟
- Find inspiration and examples in other Dotfiles repositories:
    - [dotfiles.github.io](https://dotfiles.github.io/)
    - [nvim for Laravel lady](https://github.com/jessarcher/dotfiles)
    - [riced linux example](https://github.com/Amitabha37377/Awful-DOTS/tree/master)
    - [some guy](https://github.com/yutkat/dotfiles/tree/main)
    - [some laravel dev](https://github.com/shxfee/dotfiles/tree/master)
    - [primeagen](https://github.com/ThePrimeagen/.dotfiles)
    - [examples on arch wiki](https://wiki.archlinux.org/title/Dotfiles#User_repositories)
