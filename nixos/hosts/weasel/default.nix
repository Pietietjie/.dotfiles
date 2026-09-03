{ ... }:
{
  nixosHosts.weasel = {
    system = "x86_64-linux";
    defaultUsername = "weasel";

    modules = [
      ./_nixos
    ];

    homeManagerModules = [
      ./_home
    ];
  };
}
