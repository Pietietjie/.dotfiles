# .dotfiles

My personal dotfile config ✍️(◔◡◔)

## Install
- For Linux (only really Ubuntu atm) run
```bash
bash <(curl -sS https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap)
```
- For Windows run
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap" -OutFile "$env:TEMP\bootstrap.ps1"
& "$env:TEMP\bootstrap.ps1"
```
### Troubleshooting/Tips/Common issues
- If nvim complains and says "nvim no parser for 'markdown' language" run `:TSInstall markdown markdown_inline`
## TODO
- Find inspiration and examples in other Dotfiles repositories:
    - [dotfiles.github.io](https://dotfiles.github.io/) 
    - [nvim for Laravel lady](https://github.com/jessarcher/dotfiles)
    - [riced linux example](https://github.com/Amitabha37377/Awful-DOTS/tree/master)
    - [some guy](https://github.com/yutkat/dotfiles/tree/main)
    - [some laravel dev](https://github.com/shxfee/dotfiles/tree/master).
    - [primeagen](https://github.com/ThePrimeagen/.dotfiles)
- NVIM:
    - [undo tree](https://github.com/mbbill/undotree)
    - [refactor plugin](https://github.com/ThePrimeagen/refactoring.nvim)
    - [trouble plugin](https://github.com/folke/trouble.nvim)
    - Nvim add file spesific git history?
    - Nvim go to the diff of a git blame
    - Look at getting a [ debugger for nvim ](https://github.com/mfussenegger/nvim-dap)
    - Look creating functionality that allow Telescope buffer fuzzy finder to close buffers
- Look at implementing the [windows dotbot plugin](https://github.com/kurtmckee/dotbot-windows)
- Look at a better way to add long paths when writing commands like `cp` and `mv`
- System preferences/settings
