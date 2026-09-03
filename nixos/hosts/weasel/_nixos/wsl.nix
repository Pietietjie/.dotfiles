{ inputs, username, lib, ... }:
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = false;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.boot.initTimeout = 40000;
  };

  networking.networkmanager.enable = lib.mkForce false;
  security.protectKernelImage = lib.mkForce false;
  services.dbus.enable = true;
}
