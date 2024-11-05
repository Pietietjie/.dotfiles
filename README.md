# .dotfiles

My personal dotfile config

## Steps
1. Clone the submodules with `git submodule init && git submodule update`

2. When installing apt packages run `sudo ./install -c install-ubuntu.conf.yaml -p dotbot-aptget/aptget.py`
    - This requires Python version 3.5+

3. Run `./install` to set up all the config files

4. Run `./getnf/getnf` and select the Nerd Font that you wish to install

## TODO
- Look at a better way to add long paths when writing commands like `cp` and `mv`
- Nvim add file spesific git history
- Nvim go to the diff of a git blame
- Look at getting a [ debugger for nvim ](https://github.com/mfussenegger/nvim-dap)
- Look creating functionality that allow Telescope buffer fuzzy finder to close buffers
- System preferences/settings
- Find inspiration and examples in other Dotfiles repositories at [dotfiles.github.io](https://dotfiles.github.io/) or [nvim for Laravel lady](https://github.com/jessarcher/dotfiles) or [riced linux example](https://github.com/Amitabha37377/Awful-DOTS/tree/master) or [some guy](https://github.com/yutkat/dotfiles/tree/main) or [some laravel dev](https://github.com/shxfee/dotfiles/tree/master).
- Make that this install can just be done on a new pc via curl [see](https://github.com/nickjj/dotfiles)
