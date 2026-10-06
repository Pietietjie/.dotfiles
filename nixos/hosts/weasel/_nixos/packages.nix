{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    autoconf
    gnumake
    gcc
    python3
    pkg-config
    autoconf
  ];
}
