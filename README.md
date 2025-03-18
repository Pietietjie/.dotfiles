# .dotfiles

My personal dotfile config

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

- If nvim complains and says "nvim no parser for 'markdown' language" run `:TSInstall markdown markdown_inline`
## TODO
- Look at implementing the [windows dotbot plugin](https://github.com/kurtmckee/dotbot-windows)
- look into highlighting for twig files
- Look at a better way to add long paths when writing commands like `cp` and `mv`
- Nvim add file spesific git history?
- Nvim go to the diff of a git blame
- Look at getting a [ debugger for nvim ](https://github.com/mfussenegger/nvim-dap)
- Look creating functionality that allow Telescope buffer fuzzy finder to close buffers
- System preferences/settings
- Find inspiration and examples in other Dotfiles repositories at [dotfiles.github.io](https://dotfiles.github.io/) or [nvim for Laravel lady](https://github.com/jessarcher/dotfiles) or [riced linux example](https://github.com/Amitabha37377/Awful-DOTS/tree/master) or [some guy](https://github.com/yutkat/dotfiles/tree/main) or [some laravel dev](https://github.com/shxfee/dotfiles/tree/master).
- [undo tree](https://github.com/mbbill/undotree)
- [refactor plugin](https://github.com/ThePrimeagen/refactoring.nvim)
- [trouble plugin](https://github.com/folke/trouble.nvim)
