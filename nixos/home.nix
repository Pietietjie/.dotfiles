{ pkgs, inputs, ... }:
{
    home.username = "pietietjie";
    home.homeDirectory = "/home/pietietjie";
    home.stateVersion = "25.11";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.sessionPath = [
        "$HOME/.local/bin"
    ];

    home.file.".path" = {
        source = ../shell/.path;
        force = true;
    };

    home.file.".bashrc" = {
        source = ../bash/.bashrc;
        force = true;
    };

    home.file.".gitconfig" = {
        source = ../git/.gitconfig;
        force = true;
    };

    home.file.".tmux.conf" = {
        source = ../tmux/.tmux.conf;
        force = true;
    };

    home.file.".zshrc" = {
        source = ../zsh/.zshrc;
        force = true;
    };

    home.file.".oh-my-zsh/themes/pietietjie.zsh-theme" = {
        source = ../zsh/pietietjie.zsh-theme;
        force = true;
    };

    home.file.".oh-my-zsh/custom/themes/pietietjie.zsh-theme" = {
        source = ../zsh/pietietjie.zsh-theme;
        force = true;
    };

    home.file.".local/share/noctalia" = {
        source = ../noctalia;
        recursive = true;
        force = true;
    };

    home.file.".local/bin/scrp" = {
        source = ../zsh/scrp;
        executable = true;
        force = true;
    };

    xdg.configFile."alacritty" = {
        source = ../alacritty;
        recursive = true;
        force = true;
    };

    xdg.configFile."nvim" = {
        source = ../nvim;
        recursive = true;
        force = true;
    };

    xdg.configFile."niri/config.kdl" = {
        source = ../niri/config.kdl;
        force = true;
    };
}
