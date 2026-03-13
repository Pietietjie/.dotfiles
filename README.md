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
- [ ] create a tagging system that will allow sunsetting some software or os support that I don't use for if I ever change my mind
- [ ] make that I can include operating system config including windows [windows dotbot plugin](https://github.com/kurtmckee/dotbot-windows) & wsl (nix kind of works that way allready.)
- [ ] move scrp to a [cli tool](https://github.com/charmbracelet/bubbletea) in it own project
- [ ] make that the install script can uninstall
- [ ] make a [cli tool](https://github.com/charmbracelet/bubbletea) for managing nix builds
- NVIM:
    - [ ] fix emojis breaking the spacing on windows (😔)
        - caused by LSP, snippets, tokyo night theme, & vim.opt.termguicolors = true
    - [ ] Look at getting a [debugger for nvim](https://github.com/mfussenegger/nvim-dap)
    - [ ] Make that code can be copied with highlighting as it is in nvim like vs code does (when pasting in word then it looks like the code does in the editor)
    - [ ] make that telescope buffers does not filter
## Tools to look at
- CLI tools:
    - [mise](https://github.com/jdx/mise) - a tool that manages version of dev tools & languages
    - [zoxide](https://github.com/ajeetdsouza/zoxide) - a smarter cd
    - [eza](https://github.com/eza-community/eza) - improved ls
    - [tldr](https://github.com/tldr-pages/tldr) - shorter man page
    - [bat](https://github.com/sharkdp/bat) - improved cat has syntax highligting
    - [mmv-go](https://github.com/itchyny/mmv) - cli tool for bulk renaming
- Nixos - GUI
    - [cliphist](https://mynixos.com/nixpkgs/package/cliphist) - clipboard history
    - [dunst](https://github.com/dunst-project/dunst) \w [libnotify](https://github.com/GNOME/libnotify) - notifications
    - [grim](https://sr.ht/~emersion/grim/) \w [slurp](https://github.com/emersion/slurp) \w [swappy](https://github.com/jtheoof/swappy) - screenshots
- Nvim plugs:
    - Look at AI plugins [super maven](https://github.com/supermaven-inc/supermaven-nvim) & [avante](https://github.com/yetone/avante.nvim)
    - [mini highlight plugin](https://github.com/nvim-mini/mini.hipatterns) allows very custom highlighting example having hex colors render with that color as a bg
    - [mini test](https://nvim-mini.org/mini.nvim/readmes/mini-test.html)
    - [mini split join](https://github.com/nvim-mini/mini.splitjoin)
    - [mini misc](https://nvim-mini.org/mini.nvim/readmes/mini-misc.html)
    - [mini cursor words](https://nvim-mini.org/mini.nvim/readmes/mini-cursorword.html)
    - [mini identscope](https://nvim-mini.org/mini.nvim/readmes/mini-indentscope.html) replacement for some of my current indentation related things `ii` looks more like how I would want it
    - [mini align plug](https://github.com/nvim-mini/mini.align)
    - [refactor plugin](https://github.com/ThePrimeagen/refactoring.nvim)
    - [trouble plugin](https://github.com/folke/trouble.nvim)
## 🌱 Inspiration 🌟
- Find inspiration and examples in other Dotfiles repositories:
    - [dotfiles.github.io](https://dotfiles.github.io/)
    - [nvim for Laravel lady](https://github.com/jessarcher/dotfiles)
    - [riced linux example](https://github.com/Amitabha37377/Awful-DOTS/tree/master)
    - [some guy](https://github.com/yutkat/dotfiles/tree/main)
    - [some laravel dev](https://github.com/shxfee/dotfiles/tree/master)
    - [primeagen](https://github.com/ThePrimeagen/.dotfiles)
    - [examples on arch wiki](https://wiki.archlinux.org/title/Dotfiles#User_repositories)
