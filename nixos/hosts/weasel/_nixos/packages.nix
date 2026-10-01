{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mise
    gnupg
    autoconf
    gnumake
    gcc
    python3
    pkg-config
    autoconf
  ];
}
