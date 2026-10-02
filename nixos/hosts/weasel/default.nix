{ config, ... }:
{
  nixosHosts.weasel = {
    system = "x86_64-linux";
    defaultUsername = "weasel";

    modules = [
      ./_nixos
    ]
    ++ (with config.flake.modules.nixos; [
      mysql-client
    ]);

    homeManagerModules = [
      ./_home
    ];
  };
}
