{ pkgs, ... }: {
  programs = {
    niri.enable = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;
  services.upower.enable = true;
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    XCOMPOSEFILE = "/etc/XCompose";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  environment.variables.GSK_RENDERER = "ngl";
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    tokyonight-gtk-theme
    noctalia-qs
    noctalia-shell
    # GUIs
    keepassxc
    fuzzel
    kitty
    mpv
    imv
    btop
    teamspeak6-client
    valent
    obsidian
    nemo
    anki

    # TOOLS
    xwayland-satellite
    qt6Packages.fcitx5-configtool
    hyprpicker
    wl-clipboard
    mangohud
    protonup-qt
  ];
}
