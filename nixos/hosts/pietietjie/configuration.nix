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
  services.noctalia-shell.enable = true;

  boot.initrd.luks.devices."luks-3d37da59-f6ff-42c9-a8bd-f2032188da51".crypttabExtraOpts = [ "tpm2-device=auto" ];
  boot.initrd.availableKernelModules = [ "tpm_tis" "tpm_crb" "tpm_tis_core" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

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


  # services.xserver.libinput.enable = true;
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          leftmeta = "overload(meta, f24)";
        };
      };
    };
  };

  # Set zsh as default shell for all users.
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh/custom/";
      theme = "pietietjie";
      plugins = [
        "artisan"
        "npm"
        "composer"
        "git"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "docker"
        "docker-compose"
      ];
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.pietietjie = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;
  programs.yazi.enable = true;
  # programs.thunar.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    sbctl
    python3
    git
    tmux
    tldr
    bat
    eza
    zoxide
    wget
    zig

    neovim
    fzf
    ripgrep
    nodejs_20
    fd
    sqlite
    sqlite.out
    jq

    unzip

    keepassxc
    fuzzel
    hyprpicker
    alacritty
    kitty
    mpv
    imv
    btop
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
