{ pkgs, inputs, config, ... }:
let
    username = "pietietjie";
    homeDirectory = "/home/${username}";
    dotfilesPath = "${homeDirectory}/.dotfiles";
    stateVersion = "25.11";
in {
    home.username = username;
    home.homeDirectory = homeDirectory;
    home.stateVersion = stateVersion;

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

        vimix-cursors
        vimix-icon-theme
    ];

    gtk = {
        enable = true;

        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };

        cursorTheme = {
            name = "Vimix-cursors";
            package = pkgs.vimix-cursors;
            size = 24;
        };
    };

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Vimix-cursors";
        package = pkgs.vimix-cursors;
        size = 24;
    };

    qt = {
        enable = true;
    };

    xdg.configFile."gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-icon-theme-name=Vimix
        gtk-cursor-theme-name=Vimix-cursors
        gtk-cursor-theme-size=24
    '';

    xdg.configFile."gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-icon-theme-name=Vimix
        gtk-cursor-theme-name=Vimix-cursors
        gtk-cursor-theme-size=24
    '';

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
