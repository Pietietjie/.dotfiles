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
  services.xserver.xkb.options = "compose:ralt";

  environment.etc."XCompose".text = ''
        include "${pkgs.xorg.libX11}/share/X11/locale/en_US.UTF-8/Compose"
        <Multi_key> <equal> <e> : "€" U20AC
        <Multi_key> <minus> <minus> <minus> : "—" U2014
        <Multi_key> <minus> <minus> : "–" U2013
        <Multi_key> <o> <c> : "©" U00A9
        <Multi_key> <o> <r> : "®" U00AE
        <Multi_key> <e> <asciicircum> : "ê" U00EA
        <Multi_key> <E> <asciicircum> : "Ê" U00CA
        <Multi_key> <a> <asciicircum> : "â" U00E2
        <Multi_key> <A> <asciicircum> : "Â" U00C2
        <Multi_key> <o> <asciicircum> : "ô" U00F4
        <Multi_key> <O> <asciicircum> : "Ô" U00D4
        <Multi_key> <u> <asciicircum> : "û" U00FB
        <Multi_key> <U> <asciicircum> : "Û" U00DB
        <Multi_key> <i> <asciicircum> : "î" U00EE
        <Multi_key> <I> <asciicircum> : "Î" U00CE
        <Multi_key> <apostrophe> <e> : "é" U00E9
        <Multi_key> <apostrophe> <E> : "É" U00C9
        <Multi_key> <n> <asciitilde> : "ñ" U00F1
        <Multi_key> <N> <asciitilde> : "Ñ" U00D1
  '';

  environment.sessionVariables.XCOMPOSEFILE = "/etc/XCompose";

  programs.regreet.enable = true;
  services.greetd.enable = true;
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.GSK_RENDERER = "ngl";
  
  services.noctalia-shell.enable = true;
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
    wlr-randr
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
