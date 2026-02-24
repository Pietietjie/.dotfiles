# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Deployment

Apply dotfile symlinks (Linux/Arch):
```bash
./install_dotbot
```

Apply dotfile symlinks with elevated privileges (links requiring root, e.g. `/etc/pkglist.txt`):
```bash
sudo ./install_dotbot
```

Install packages and set up everything on Ubuntu/Debian from scratch:
```bash
./install
```

Fresh bootstrap on a new machine (clones repo + runs install):
```bash
bash <(curl -sS https://raw.githubusercontent.com/Pietietjie/.dotfiles/main/bootstrap)
```

Manage dotfiles from any directory using the git alias:
```bash
git dotfiles <git-command>   # e.g. git dotfiles status
```

## Architecture

### Dotbot Symlink Management
[Dotbot](https://github.com/anishathalye/dotbot) (git submodule at `dotbot/`) manages symlinks from `~/.dotfiles/` into the home directory. `install.conf.yaml` defines the Linux symlink targets. `windows.conf.yml` handles Windows. `install-ubuntu.conf.yaml` is for apt package installation (used with dotbot-aptget plugin). The `install_dotbot` script syncs the submodule and runs dotbot.

### Neovim Config (`nvim/`)
All configuration lives in a **single `nvim/init.lua`** file — no split plugin files. [lazy.nvim](https://github.com/folke/lazy.nvim) is the plugin manager. LSP servers are managed via Mason (`mason.nvim` + `mason-lspconfig`). Configured LSPs: `lua_ls`, `intelephense` (PHP), `html`, `tailwindcss`, `emmet_language_server`, `twiggy_language_server`.

A global `l` variable is available in all Lua code for logging:
```lua
l.info("message")   -- l.trace / l.debug / l.warn / l.error
```
This is set up in `nvim/init.lua` via `l = require('pietietjie.loggers')` and the module lives at `nvim/lua/pietietjie/loggers.lua`.

Navigation bindings (`]b`/`[b`, `]q`/`[q`, `]h`/`[h`, etc.) use `make_repeatable_move_pair()` which wraps `nvim-treesitter-textobjects`'s repeatable move API so they work with vim count and `;`/`,` repeat.

### Tmux (`tmux/`)
Prefix key is `Ctrl+Space`. Vi mode enabled. Session blueprints are defined in `~/tmux-sessions.json` (copied from `tmux/tmux-sessions.example.json` on first install). The `scripts/1-tmux-start.sh` script reads this JSON and creates sessions/windows/panes via fzf selection.

### Zsh (`zsh/`)
Uses oh-my-zsh with a custom theme (`zsh/pietietjie.zsh-theme`). Plugins: artisan, npm, composer, git, zsh-autosuggestions, zsh-syntax-highlighting, docker, docker-compose. The `zsh/scrp` script is symlinked to `/usr/local/bin/scrp` (requires root).

### Git Config (`git/.gitconfig`)
Heavy use of aliases. Key ones:
- `git a` — stage all (or specific files)
- `git s` — short status
- `git c` — commit --verbose
- `git pl` — fetch + pull
- `git fz` — checkout branch via fzf
- `git dotfiles <cmd>` — run git commands on the dotfiles repo from any directory

### Commit Convention
Commits use gitmoji (emoji prefix). LuaSnip snippets in `nvim/init.lua` provide trigger words like `:feat:` → `✨`, `:bug:` → `🐛`, `:docs:` → `📝`, `:refactor:` → `♻️`, etc. for use in gitcommit buffers.
