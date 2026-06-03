# WSL configuration for weasel host
# Shell environment only - no UI apps

{ config, pkgs, lib, username, ... }:
{
  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    # Workaround for systemd user session failing with "Device or resource busy"
    # when other WSL distros are running (upstream bug: microsoft/WSL#13826)
    wslConf.boot.initTimeout = 40000;
  };

  networking.hostName = "weasel";

  # WSL handles networking
  networking.networkmanager.enable = lib.mkForce false;

  # Enable dbus for systemd user services
  services.dbus.enable = true;

  # WSL doesn't need kernel image protection
  security.protectKernelImage = lib.mkForce false;

  # Define a user account
  users.users.${username} = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [ "wheel" ];
  };
}
