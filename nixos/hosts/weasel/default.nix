{ config, ... }:
{
  system.stateVersion = "26.05";
  nixosHosts.weasel = {
    system = "x86_64-linux";
    defaultUsername = "weasel";

    modules = [
      ./_nixos
    ]
    ++ (with config.flake.modules.nixos; [
      mysql-client
      claude
    ]);

    homeManagerModules = [
      ./_home
    ];
  };
}
