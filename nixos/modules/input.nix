{ pkgs, ...}: {
  fonts = {
    packages = (with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans      # CJK (Chinese, Japanese, Korean)
      fira-code
      fira-code-symbols
      dina-font
      proggyfonts
      udev-gothic-nf
      font-awesome
      cantarell-fonts
    ]);
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "UDEV Gothic 35NFLG" ];
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };
  environment.etc."XCompose".source = ../etc/xcompose.conf;
  services.xserver.xkb.options = "compose:ralt,ctrl:nocaps";
  systemd.user.services.fcitx5 = {
    description = "Fcitx5 input method";
    wantedBy = [ "default.target" ];
    after = [ "default.target" ];

    environment = {
      QT_PLUGIN_PATH = "${pkgs.libsForQt5.qtwayland.bin}/lib/qt-${pkgs.libsForQt5.qtbase.version}/plugins";
    };

    serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/fcitx5";
        Restart = "on-failure";
    };
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-qt
      im-emoji-picker
      fcitx5-tokyonight
    ];
  };
}
