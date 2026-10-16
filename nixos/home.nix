# Base home configuration - shell environment
# Host-specific GUI config is in hosts/<hostname>/home.nix

{ config, lib, pkgs, username, homeDir ? "/home/${username}", ... }:
let
    homeDirectory = homeDir;
    dotfilesPath = "${homeDirectory}/.dotfiles";
    stateVersion = "26.05";

    mkOmzPlugin = name: src: pkgs.runCommand "omz-plugin-${name}" { } ''
        mkdir -p $out
        cp -r ${src}/. $out/
        chmod -R u+w $out
        if [ ! -e "$out/${name}.plugin.zsh" ] && [ -e "$out/${name}.zsh" ]; then
            ln -s "${name}.zsh" "$out/${name}.plugin.zsh"
        fi
    '';

    zshArtisanSrc = pkgs.fetchFromGitHub {
        owner = "jessarcher";
        repo = "zsh-artisan";
        rev = "4063d53fd310f715c7a8fb7d4e133812ef0b3128";
        hash = "sha256-O0Tn9zQWR0i7UWJ9VtOvxjqpqz9Sj7aKogdHZSOATC0=";
    };
in {
    home.username = username;
    home.homeDirectory = lib.mkForce homeDirectory;
    home.stateVersion = stateVersion;

    programs.home-manager.enable = true;

    # Auto-enter per-project nix dev shells (see .envrc -> `use flake`)
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = false;
        enableZshIntegration = false;
    };

    home.sessionPath = [
        "$HOME/.local/bin"
    ];

    # Shell dotfiles
    home.file.".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/bash/.bashrc";
        force = true;
    };

    home.file.".gitconfig" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/git/.gitconfig";
        force = true;
    };

    home.file.".tmux.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux/.tmux.conf";
        force = true;
    };

    home.file.".zshrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/.zshrc";
        force = true;
    };

    home.file.".oh-my-zsh/themes/pietietjie.zsh-theme" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/pietietjie.zsh-theme";
        force = true;
    };

    home.file.".oh-my-zsh/custom/themes/pietietjie.zsh-theme" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/pietietjie.zsh-theme";
        force = true;
    };

    home.file.".oh-my-zsh/custom/plugins/artisan" = {
        source = mkOmzPlugin "artisan" zshArtisanSrc;
        force = true;
    };

    home.file.".oh-my-zsh/custom/plugins/zsh-autosuggestions" = {
        source = mkOmzPlugin "zsh-autosuggestions"
            "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
        force = true;
    };

    home.file.".oh-my-zsh/custom/plugins/zsh-syntax-highlighting" = {
        source = mkOmzPlugin "zsh-syntax-highlighting"
            "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
        force = true;
    };

    # CLI tools config
    xdg.configFile."starship.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship/starship.toml";
        force = true;
    };

    xdg.configFile."nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
        recursive = true;
        force = true;
    };

    xdg.configFile."yazi" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/yazi";
        recursive = true;
        force = true;
    };

    # Claude Code config
    home.file.".claude/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/claude/settings.json";
        force = true;
    };

    home.file.".claude/CLAUDE.md" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/claude/CLAUDE.md";
        force = true;
    };

    home.file.".claude/skills" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/claude/skills";
        recursive = true;
        force = true;
    };

    # User bin scripts
    home.file.".local/bin/scrp" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/scrp";
    };

    # Copy tmux-sessions.example.json to ~/tmux-sessions.json if it doesn't exist or is empty
    home.activation.copyTmuxSessions = config.lib.dag.entryAfter ["writeBoundary"] ''
        if [ ! -s "${homeDirectory}/tmux-sessions.json" ]; then
            $DRY_RUN_CMD cp "${dotfilesPath}/tmux/tmux-sessions.example.json" "${homeDirectory}/tmux-sessions.json"
        fi
    '';

    # Create telescope history database file if it doesn't exist
    home.activation.createTelescopeHistory = config.lib.dag.entryAfter ["writeBoundary"] ''
        if [ ! -f "${homeDirectory}/.local/share/nvim/databases/telescope_history.sqlite3" ]; then
            $DRY_RUN_CMD mkdir -p "${homeDirectory}/.local/share/nvim/databases"
            $DRY_RUN_CMD touch "${homeDirectory}/.local/share/nvim/databases/telescope_history.sqlite3"
        fi
    '';
}
