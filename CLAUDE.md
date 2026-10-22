# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Two deployment paths

This repo serves NixOS hosts (the primary target) and Windows. They use different symlink mechanisms for the same config directories — check which host you are on before assuming.

### NixOS (primary)

Hosts are `weasel` (WSL2) and `pietietjie` (desktop, niri). Rebuild:
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#<hostname>
```

Home-manager runs as a NixOS module, so a rebuild also applies the home config. `NIX_USERNAME` overrides the host's `defaultUsername` at evaluation time.

### Windows

Install packages (Chocolatey), shortcuts and symlinks from scratch:
```powershell
.\install.ps1
```

Apply only the symlinks:
```powershell
.\install_dotbot.ps1
```

Fresh bootstrap on a new machine (clones repo + runs `install.ps1`): `bootstrap.ps1`. Teardown: `uninstall.ps1`.

Manage dotfiles from any directory using the git alias:
```bash
git dotfiles <git-command>   # e.g. git dotfiles status
```

## Architecture

### Nix flake (`flake.nix`, `flake/`)

Built with [flake-parts](https://flake.parts) + [import-tree](https://github.com/vic/import-tree): `flake.nix` imports every file under `flake/` automatically.

- `flake/hosts.nix` — defines the `nixosHosts` option and turns each entry into a `nixosConfigurations` output. Every host gets `nixos/configuration.nix`, the overlay module, and home-manager with `nixos/home.nix`.
- `flake/hosts-registry.nix` — the explicit list of host directories to import.
- `flake/modules-nixos.nix` — auto-exposes every `nixos/modules/*.nix` as `flake.modules.nixos.<name>`. **Files prefixed with `_` are skipped** (e.g. `_wallpaper-engine.nix` is parked, not wired up).
- `flake/overlays.nix` — overlay for locally packaged derivations in `nixos/pkgs/`.
- `flake/options.nix` — declares the `flake.modules` option type.

### NixOS config (`nixos/`)

- `configuration.nix` — shared system config: zsh + oh-my-zsh (plugin list must stay in sync with `zsh/.zshrc`), system packages, GC, locale.
- `home.nix` — shared home config. Symlinks dotfiles back into the repo with `mkOutOfStoreSymlink`, so edits in `~/.dotfiles` take effect without a rebuild. Also provides the oh-my-zsh custom plugins and the activation scripts below.
- `hosts/<name>/default.nix` — sets `nixosHosts.<name>` (system, username, which `flake.modules.nixos` to pull in).
- `hosts/<name>/_nixos/` — host system modules. `hosts/<name>/_home/` — host home modules.
- `modules/` — reusable system modules shared between hosts.
- `pkgs/` — local package derivations consumed by the overlay.

Home-manager activation scripts in `home.nix`:
- `copyTmuxSessions` — seeds `~/tmux-sessions.json` from the example.
- `createTelescopeHistory` — creates the telescope history sqlite file.
- `nvimLazyRestore` — runs `nvim --headless +Lazy! restore` so plugins are pre-installed at the commits pinned in `nvim/lazy-lock.json`; re-runs only when the lockfile hash changes.

### Dotbot symlink management (Windows only)

[Dotbot](https://github.com/anishathalye/dotbot) (git submodule at `dotbot/`) manages symlinks from the repo into the home directory. `windows.conf.yml` defines the targets; the `install_dotbot.ps1` script syncs the submodule and runs dotbot against it.

`windows.conf.yml` and `home.nix` link an overlapping but not identical set of files — if you add a config directory, wire it into both.

### Neovim config (`nvim/`)

All configuration lives in a **single `nvim/init.lua`** file — no split plugin files. [lazy.nvim](https://github.com/folke/lazy.nvim) is the plugin manager. LSP servers are managed via Mason (`mason.nvim` + `mason-lspconfig`); the `servers` table near the bottom of `init.lua` is the source of truth and feeds `ensure_installed`. Configured LSPs: `lua_ls`, `intelephense` (PHP), `html`, `tailwindcss`, `emmet_language_server`, `twiggy_language_server`.

`nvim/after/queries/` holds extra treesitter textobject queries (bash, php). `nvim/spell/` holds spell files.

All user-created Lua modules live under `nvim/lua/pietietjie/`. New files should be placed there and required via `require('pietietjie.<module>')`. Current modules:
- `loggers.lua` — provides the global `l` logger
- `langmap.lua` — returns the `vim.o.langmap` string
- `heredoc.lua` — heredoc language injection handling
- `colors.lua` — colour helpers
- `quotes.lua` — `.setup()` for quote handling
- `incremental_selection.lua` — treesitter incremental selection
- `snippets/` — per-filetype LuaSnip snippet files, each returning a table of snippets. Loaded in `init.lua` via `ls.add_snippets('<filetype>', require('pietietjie.snippets.<filetype>'))`. Current files: `gitcommit`, `php`, `twig`, `javascript` (registered for both `javascript` and `typescript`), `all`.

A global `l` variable is available in all Lua code for logging:
```lua
l.info("message")   -- l.trace / l.debug / l.warn / l.error
```
This is set up in `nvim/init.lua` via `l = require('pietietjie.loggers')`.

Navigation bindings (`]b`/`[b`, `]q`/`[q`, `]h`/`[h`, etc.) use `make_repeatable_move_pair()` which wraps `nvim-treesitter-textobjects`'s repeatable move API so they work with vim count and `;`/`,` repeat.

### Tmux (`tmux/`)

Prefix key is `Ctrl+Space`. Vi mode enabled. Session blueprints are defined in `~/tmux-sessions.json` (copied from `tmux/tmux-sessions.example.json` on first install). The `scripts/1-tmux-start.sh` script reads this JSON and creates sessions/windows/panes via fzf selection.

### Shell (`zsh/`, `bash/`, `shell/`, `starship/`)

Zsh uses oh-my-zsh for plugins only — `ZSH_THEME` is empty and the **prompt comes from starship** (`starship/starship.toml`). `zsh/pietietjie.zsh-theme` is still symlinked into `~/.oh-my-zsh/{themes,custom/themes}/` but is not the active prompt.

Plugins: artisan, npm, composer, git, zsh-autosuggestions, zsh-syntax-highlighting, docker, docker-compose. The third-party ones (artisan, zsh-autosuggestions, zsh-syntax-highlighting) are provided declaratively by `nixos/home.nix` into `~/.oh-my-zsh/custom/plugins/`. The plugin list is duplicated in `nixos/configuration.nix` (`programs.zsh.ohMyZsh.plugins`) — keep both in sync.

`shell/.path` is a template for a per-machine `~/.path` (sourced by `.zshrc`/`.bashrc` when present). Nothing copies it automatically — copy it by hand on a new machine.

The `zsh/scrp` script lands at `~/.local/bin/scrp` on NixOS.

### Git config (`git/.gitconfig`)

Heavy use of aliases. Key ones:
- `git a` — stage all (or specific files)
- `git s` — short status
- `git c` — commit --verbose
- `git pl` — fetch + pull
- `git fz` — checkout branch via fzf
- `git dotfiles <cmd>` — run git commands on the dotfiles repo from any directory

### Other config directories

- `niri/`, `noctalia/`, `fcitx5/`, `nemo/`, `kitty/` — linked only on the `pietietjie` host via `nixos/hosts/pietietjie/_home/`
- `yazi/` — linked by the shared `nixos/home.nix`
- `alacritty/` — linked by `windows.conf.yml`
- `wezterm/`, `vim/`, `Aliases/`, `shortcuts/` — present in the repo but not linked by `home.nix`; check `windows.conf.yml` before assuming a target
- `claude/` — Claude Code config (`CLAUDE.md`, `settings.json`, `skills/`) linked into `~/.claude/`
- `scripts/` — numbered helper scripts (tmux start, remove swapfiles, kill apache, fix corrupt history, tmux sessions, rssguard OPML export)
- `winget/`, `powershell/`, `powertoys/` — Windows package lists and config

### Private data (`secrets` flake input)

The YouTube subscription list is personal, so it lives outside this public repo in
the **private** `Pietietjie/dotfiles-secrets` repo, consumed as a non-flake input:

```nix
secrets = {
  url = "git+ssh://git@github.com/Pietietjie/dotfiles-secrets.git";
  flake = false;
};
```

`nixos/modules/rssguard.nix` does `import "${inputs.secrets}/subscriptions.nix"` and
renders it to OPML, exposing `rssguard-opml` to write the file out for import.

After editing the list in the private repo, commit and push it, then here:

```bash
nix flake update secrets
```

Fetching needs SSH access to the private repo. Run `nix flake update secrets` as your
user (not under `sudo`) so your key is used — the content lands in `/nix/store` and the
later `sudo nixos-rebuild` reuses the locked revision without re-fetching.

Note this keeps the list off GitHub, not off the machine: `/nix/store` is world-readable,
so the subscriptions are plaintext locally.

### Commit convention

Commits use gitmoji (emoji prefix). LuaSnip snippets in `nvim/lua/pietietjie/snippets/gitcommit.lua` provide trigger words like `:feat:` → `✨`, `:bug:` → `🐛`, `:docs:` → `📝`, `:refactor:` → `♻️`, etc. for use in gitcommit buffers.
