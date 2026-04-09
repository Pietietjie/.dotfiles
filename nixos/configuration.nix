# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:
{
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

  security.sudo.extraConfig = "Defaults env_reset,pwfeedback, timestamp_timeout=15";

  system.activationScripts.bash = ''
    mkdir -p /bin
    ln -sf /run/current-system/sw/bin/bash /bin/bash
  '';

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

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # cli
    gnutar
    sbctl
    python3
    git
    tmux
    tldr
    bat
    eza
    zoxide
    wget
    unzip
    claude-code

    # edit & dep
    neovim
    fzf
    zig
    ripgrep
    nodejs_20
    fd
    sqlite
    sqlite.out
    jq

  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
