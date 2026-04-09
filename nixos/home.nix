# Base home configuration - shell environment
# Host-specific GUI config is in hosts/<hostname>/home.nix

{ pkgs, config, username, hostSpecificHomeConfig ? null, ... }:
let
    homeDirectory = "/home/${username}";
    dotfilesPath = "${homeDirectory}/.dotfiles";
    stateVersion = "25.11";
in {
    imports = if hostSpecificHomeConfig != null
        then [ hostSpecificHomeConfig ]
        else [];

    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = stateVersion;

    programs.home-manager.enable = true;

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

    # CLI tools config
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

    # User bin scripts
    home.file.".local/bin/scrp" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/scrp";
    };
}
