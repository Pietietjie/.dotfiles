{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker_29
    docker-compose
    mise
    autoconf
  ];
}
