{ pkgs, inputs, config, ... }:
let
    username = "pietietjie";
    homeDirectory = "/home/pietietjie";
    dotfilesPath = "${homeDirectory}/dotfiles";
    stateVersion = "25.11";
in {
    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = stateVersion;

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.sessionPath = [
        "$HOME/.local/bin"
    ];

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

    home.file.".local/share/noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/noctalia";
        recursive = true;
        force = true;
    };

    home.file.".local/bin/scrp" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/scrp";
        executable = true;
        force = true;
    };

    xdg.configFile."alacritty" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/alacritty";
        recursive = true;
        force = true;
    };

    xdg.configFile."nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
        recursive = true;
        force = true;
    };

    xdg.configFile."niri/config.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/niri/config.kdl";
        force = true;
    };
}
