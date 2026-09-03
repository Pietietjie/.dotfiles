{ inputs, ... }:
{
  imports = [
    ../nixos/hosts/pietietjie
  ];

  nixosHosts.weasel = {
    system = "x86_64-linux";
    defaultUsername = "weasel";
    modules = [
      inputs.nixos-wsl.nixosModules.wsl
      ../nixos/hosts/weasel/configuration.nix
    ];
    homeManagerModules = [
      ../nixos/hosts/weasel/home.nix
    ];
  };
}
