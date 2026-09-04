{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    docker_29
    docker-compose
  ];

  # Docker Desktop (Windows) provides the daemon via WSL integration.
  # Point CLI at the shared socket it exposes under /mnt/wsl.
  environment.sessionVariables = {
    DOCKER_HOST = "unix:///mnt/wsl/docker-desktop/shared-sockets/guest-services/docker.proxy.sock";
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
