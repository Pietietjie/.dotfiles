{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mise
    autoconf
  ];
}
