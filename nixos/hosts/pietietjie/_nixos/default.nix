{ hostname, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./nvidia.nix
  ];

  networking.hostName = hostname;

  programs.dconf.enable = true;

  services.printing.enable = true;
}
