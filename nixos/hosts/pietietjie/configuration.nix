# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts = {
    packages = (with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
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

  security.sudo.extraConfig = "Defaults env_reset,pwfeedback";

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


  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.pietietjie = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [ "networkmanager" "wheel" ];
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
    hyprpicker
    wl-clipboard
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
