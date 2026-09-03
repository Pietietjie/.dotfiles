{ lib, inputs, config, ... }:
let
  hostOpts = lib.types.submodule ({ name, ... }: {
    options = {
      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
      };
      defaultUsername = lib.mkOption {
        type = lib.types.str;
        default = name;
      };
      modules = lib.mkOption {
        type = lib.types.listOf lib.types.unspecified;
        default = [ ];
      };
      homeManagerModules = lib.mkOption {
        type = lib.types.listOf lib.types.unspecified;
        default = [ ];
      };
    };
  });

  mkNixosSystem = hostname: hostCfg:
    let
      envUser = builtins.getEnv "NIX_USERNAME";
      username = if envUser != "" then envUser else hostCfg.defaultUsername;
      specialArgs = {
        inherit inputs username hostname;
        homeDir = "/home/${username}";
      };
      overlayModule = config.flake.modules.nixos._overlay or { };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit (hostCfg) system;
      inherit specialArgs;
      modules = [
        overlayModule
        ../nixos/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${username} = {
            imports = [ ../nixos/home.nix ] ++ hostCfg.homeManagerModules;
          };
        }
      ] ++ hostCfg.modules;
    };
in
{
  options.nixosHosts = lib.mkOption {
    type = lib.types.attrsOf hostOpts;
    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs mkNixosSystem config.nixosHosts;
}
