{ hostname, username, ... }:
{
  imports = [
    ./wsl.nix
    ./packages.nix
    ./docker.nix
    ./windows_interop.nix
  ];

  networking.hostName = hostname;

  users.users.${username} = {
    isNormalUser = true;
    description = "Pieter Louis van der Meijden";
    extraGroups = [
      "wheel"
    ];
  };
}
