# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.kernelPackages = pkgs.linuxPackages_6_12;  # LTS kernel for NVIDIA compatibility
  boot.kernelModules = [ "usbhid" "uhci_hcd" "ehci_hcd" "xhci_hcd" ];

  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices."luks-3d37da59-f6ff-42c9-a8bd-f2032188da51".crypttabExtraOpts = [ "tpm2-device=auto" ];
  boot.initrd.availableKernelModules = [ "tpm_tis" "tpm_crb" "tpm_tis_core" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.xkb.options = "compose:ralt";

  environment.etc."XCompose".source = ../../etc/xcompose.conf;

  programs.regreet = {
    enable = true;
    cageArgs = [ "-m" "last" ];
    settings = {
      GTK.theme_name = lib.mkForce "Adwaita-dark";
    };
  };
  services.greetd.enable = true;
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    XCOMPOSEFILE = "/etc/XCompose";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  environment.variables.GSK_RENDERER = "ngl";

  services.noctalia-shell.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.pietietjie = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="3297", ENV{ID_MODEL_ID}=="4975", MODE="0666"
  '';

  
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
    ];
  };

  programs.firefox.enable = true;
  programs.yazi.enable = true;
  # programs.thunar.enable = true;
  environment.systemPackages = with pkgs; [
    # GUIs
    keepassxc
    fuzzel
    kitty
    mpv
    imv
    btop

    # TOOLS
    qt6Packages.fcitx5-configtool
    keymapp
    hyprpicker
    wl-clipboard
  ];
}
