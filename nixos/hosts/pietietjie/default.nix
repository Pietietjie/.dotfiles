{ config, ... }:
{
  nixosHosts.pietietjie = {
    system = "x86_64-linux";
    defaultUsername = "pietietjie";

    modules = [
      ./_nixos
      ({ username, ... }: {
        users.users.${username} = {
          isNormalUser = true;
          description = "Pieter Louis van der Meijden";
          extraGroups = [ "networkmanager" "wheel" ];
        };
      })
    ]
    ++ (with config.flake.modules.nixos; [
      desktop-niri
      input
      regreet
      lanzaboote
      steam
      keymapp
    ]);

    homeManagerModules = [
      ./_home
    ];
  };
}
