# .dotfiles

> *My personal dotfile config* 🔫(◔◡◔)🤏

---

## 🚀 Install

**Linux (bootstrap)**
```bash
bash <(curl -sS https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap)
```

**Windows (bootstrap)**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap" -OutFile "$env:TEMP\bootstrap.ps1"
& "$env:TEMP\bootstrap.ps1"
```

**Manual**
```bash
git submodule init && git submodule update
sudo ./install
```

## ⚠️ Troubleshooting

| Problem | Fix |
|---|---|
| nvim says "no parser for 'markdown' language" | `:TSInstall markdown markdown_inline` |
| WSL 2 docker containers not accessible in Chromium | `sudo service apache2 stop` or `sudo systemctl stop apache2` |

## 📋 TODO

**General**
- [ ] Create a tagging system for sunsetting software/OS support
- [ ] Include OS config including Windows ([dotbot-windows](https://github.com/kurtmckee/dotbot-windows)) & WSL
- [ ] Move `scrp` to its own [CLI tool](https://github.com/charmbracelet/bubbletea) projectthat also manages the install & uninstall of the environment like a mini-me
- [ ] Build a [CLI tool](https://github.com/charmbracelet/bubbletea) for managing nix builds

**Neovim**
- [x] Open links in the browser
- [ ] fix random new lines when pasting
- [ ] fix tailwind sort
- [ ] fix blade formating & other lsp stuff
- [ ] Fix emojis breaking spacing on Windows (caused by LSP, snippets, tokyo night theme, & `termguicolors`)
- [ ] Add a [debugger](https://github.com/mfussenegger/nvim-dap)
- [ ] Copy code with highlighting (like VS Code does for Word)
- [ ] Make telescope buffers not filter

**NixOS**
- [ ] Nvidia
- [ ] make that nix shell is more like the normal shell (theme etc)
- [ ] Weasel
- [ ] look at fcitx's clipboard history
- [ ] Customize regreet or whatever it is called
- [ ] look at why I have gnome files installed
- [ ] make that scrp works and make that the tm dotfiles session is autostarts
- [ ] add fingerprint support
- [ ] make that niri workspaces are automatically there
## 🔧 Tools to look at

**CLI tools**

| Tool | Description |
|---|---|
| [mise](https://github.com/jdx/mise) | Manages versions of dev tools & languages |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | A smarter `cd` |
| [eza](https://github.com/eza-community/eza) | Improved `ls` |
| [bat](https://github.com/sharkdp/bat) | Improved `cat` with syntax highlighting |
| [mmv-go](https://github.com/itchyny/mmv) | Bulk renaming |


**Neovim plugins**

| Plugin | Description |
|---|---|
| [supermaven](https://github.com/supermaven-inc/supermaven-nvim) / [avante](https://github.com/yetone/avante.nvim) | AI plugins |
| [mini.test](https://nvim-mini.org/mini.nvim/readmes/mini-test.html) | Testing framework |
| [mini.misc](https://nvim-mini.org/mini.nvim/readmes/mini-misc.html) | Miscellaneous utilities |
| [mini.cursorword](https://nvim-mini.org/mini.nvim/readmes/mini-cursorword.html) | Highlight word under cursor |
| [mini.indentscope](https://nvim-mini.org/mini.nvim/readmes/mini-indentscope.html) | Better `ii` indentation scope |
| [mini.align](https://github.com/nvim-mini/mini.align) | Align text |
| [refactoring.nvim](https://github.com/ThePrimeagen/refactoring.nvim) | Refactoring tools |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |
| [big plugin list](https://github.com/yutkat/my-neovim-pluginlist) | Curated plugin list |

## 🌱 Inspiration

| Repo | Note |
|---|---|
| [dotfiles.github.io](https://dotfiles.github.io/) | Community directory |
| [jessarcher/dotfiles](https://github.com/jessarcher/dotfiles) | Laravel-focused nvim |
| [Amitabha37377/Awful-DOTS](https://github.com/Amitabha37377/Awful-DOTS/tree/master) | Riced Linux example |
| [yutkat/dotfiles](https://github.com/yutkat/dotfiles/tree/main) | Comprehensive dotfiles |
| [shxfee/dotfiles](https://github.com/shxfee/dotfiles/tree/master) | Laravel dev |
| [ThePrimeagen/.dotfiles](https://github.com/ThePrimeagen/.dotfiles) | ThePrimeagen |
| [Arch Wiki examples](https://wiki.archlinux.org/title/Dotfiles#User_repositories) | Community repos |
