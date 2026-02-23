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
    - add spelling mistakes to the lua line bar
    - fix emojis breaking the spacing on windows (😔)
        - caused by LSP, snippets, tokyo night theme, & vim.opt.termguicolors = true
    - look into polyglot
    - look at an alternative to vim pasta that does not break sometimes
    - [refactor plugin](https://github.com/ThePrimeagen/refactoring.nvim)
    - [trouble plugin](https://github.com/folke/trouble.nvim)
    - Look at getting a [debugger for nvim](https://github.com/mfussenegger/nvim-dap)
    - Look at AI plugins [super maven](https://github.com/supermaven-inc/supermaven-nvim) & [avante](https://github.com/yetone/avante.nvim)
    - Make that code can be copied with highlighting as it is in nvim like vs code does
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
