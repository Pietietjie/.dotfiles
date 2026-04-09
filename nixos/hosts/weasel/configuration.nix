# WSL configuration for weasel host
# Shell environment only - no UI apps

{ config, pkgs, lib, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "pietietjie";
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
  };

  networking.hostName = "weasel";

  # WSL handles networking
  networking.networkmanager.enable = lib.mkForce false;

  # WSL doesn't need kernel image protection
  security.protectKernelImage = lib.mkForce false;

  # Define a user account
  users.users.pietietjie = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [ "wheel" ];
  };
}
