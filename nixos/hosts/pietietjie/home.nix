# GUI-specific home configuration for pietietjie host
{ pkgs, inputs, config, username, ... }:
let
    homeDirectory = "/home/${username}";
    dotfilesPath = "${homeDirectory}/.dotfiles";
in {
    home.packages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        vimix-cursors
        vimix-icon-theme
    ];

    gtk = {
        enable = true;

        iconTheme = {
            name = "Vimix";
            package = pkgs.vimix-icon-theme;
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

    services.kanshi.enable = true;

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

    xdg.configFile."kanshi/config".text = ''
        profile undocked {
            output eDP-1 enable
        }

        profile docked {
            output eDP-1 disable
            output HDMI-A-1 enable
        }
    '';

    xdg.configFile."noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/noctalia";
        recursive = true;
        force = true;
    };

    xdg.configFile."kitty" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/kitty";
        recursive = true;
        force = true;
    };

    xdg.configFile."niri" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/niri";
        recursive = true;
        force = true;
    };

    xdg.configFile."fcitx5" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/fcitx5";
        recursive = true;
        force = true;
    };
}
