{ config, ... }:
{
  nixosHosts.pietietjie = {
    system = "x86_64-linux";
    defaultUsername = "pietietjie";
    stateVersion = "25.11";

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
      documents
      games
      keymapp
      claude
    ]);

    homeManagerModules = [
      ./_home
    ];
  };
}
