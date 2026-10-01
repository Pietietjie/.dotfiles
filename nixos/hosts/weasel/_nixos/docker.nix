{ pkgs, username, ... }:
let
  ddRoot = "/mnt/wsl/docker-desktop";
  ddResources = "/mnt/c/Program Files/Docker/Docker/resources";
  distroName = "NixOS";

  linkResources = pkgs.writeShellScript "docker-desktop-link-resources" ''
    mkdir -p /opt /Docker/host
    ln -sfn '${ddResources}' /opt/docker-desktop
  '';

  proxyScript = pkgs.writeShellScript "docker-desktop-proxy" ''
    exec ${ddRoot}/docker-desktop-user-distro proxy \
      --distro-name ${distroName} \
      --docker-desktop-root ${ddRoot} \
      'C:\Program Files\Docker\Docker\resources'
  '';

  socketPerms = pkgs.writeShellScript "docker-socket-perms" ''
    for _ in $(seq 1 100); do
      [ -S /var/run/docker.sock ] && break
      sleep 0.1
    done
    chgrp docker /var/run/docker.sock
    chmod 660 /var/run/docker.sock
  '';
in
{
  environment.systemPackages = with pkgs; [
    docker-client
    docker-compose
    docker-buildx
  ];

  systemd.tmpfiles.rules = [
    "d /usr/local/lib/docker/cli-plugins 0755 root root -"
    "L+ /usr/local/lib/docker/cli-plugins/docker-compose - - - - ${pkgs.docker-compose}/bin/docker-compose"
    "L+ /usr/local/lib/docker/cli-plugins/docker-buildx - - - - ${pkgs.docker-buildx}/bin/docker-buildx"
  ];

  users.groups.docker = { };
  users.users.${username}.extraGroups = [ "docker" ];

  systemd.services.docker-desktop-proxy = {
    description = "Docker Desktop WSL integration proxy";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = with pkgs; [ coreutils util-linux iproute2 iptables ];
    serviceConfig = {
      ExecStartPre = "-${linkResources}";
      ExecStart = proxyScript;
      ExecStartPost = "-${socketPerms}";
      Restart = "always";
      RestartSec = 5;
    };
    unitConfig.StartLimitIntervalSec = 0;
  };
}
