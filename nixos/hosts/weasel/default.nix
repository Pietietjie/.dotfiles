{ config, ... }:
{
  nixosHosts.weasel = {
    system = "x86_64-linux";
    defaultUsername = "weasel";
    stateVersion = "26.05";

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
