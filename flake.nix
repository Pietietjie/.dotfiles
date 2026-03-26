{
    description = "NixOS Flake Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v1.0.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        noctalia = {
            url = "github:noctalia-dev/noctalia-shell";
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.noctalia-qs.follows = "noctalia-qs";
        };

        noctalia-qs = {
            url = "github:noctalia-dev/noctalia-qs";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, lanzaboote, home-manager, ... }@inputs:
        let
            myHosts = {
                "pietietjie" = {
                    system = "x86_64-linux";
                    hostSpecificNix = ./nixos/hosts/pietietjie/configuration.nix;
                    hostSpecificHomeConfig = ./nixos/hosts/pietietjie/home.nix;
                    enableGui = true;
                    enableSystem = true;
                    enableLanzaboote = true;
                    defaultUsername = "pietietjie";
                };
                "weasel" = {
                    system = "x86_64-linux";
                    hostSpecificNix = ./nixos/hosts/weasel/configuration.nix;
                    hostSpecificHomeConfig = ./nixos/hosts/weasel/home.nix;
                    enableGui = false;
                    enableSystem = true;
                    enableLanzaboote = false;
                    defaultUsername = "weasel";
                };
            };
            getUsernameForHost = hostname: hostAttrs:
                let
                    envUser = builtins.getEnv "NIX_USERNAME";
                    hostDefaultUser = hostAttrs.defaultUsername;
                in if envUser != "" then envUser else hostDefaultUser;

            # NixOS system configuration builder function
            mkNixosSystem = hostname: hostAttrs:
                let
                    system = hostAttrs.system;
                    username = getUsernameForHost hostname hostAttrs;
                    baseModules = [
                        ./nixos/configuration.nix
                        hostAttrs.hostSpecificNix
                        home-manager.nixosModules.home-manager
                    ];
                    lanzabooteModule = if hostAttrs.enableLanzaboote or false
                        then [ lanzaboote.nixosModules.lanzaboote ]
                    else [];
                    guiModules = if hostAttrs.enableGui
                        then [
                            inputs.noctalia.nixosModules.default
                        ]
                    else [];

                    specialArgs = {
                        inherit inputs hostname username;
                        enableGui = hostAttrs.enableGui;
                        hostSpecificHomeConfig = hostAttrs.hostSpecificHomeConfig or null;
                    };
                in nixpkgs.lib.nixosSystem {
                        inherit system specialArgs;
                        modules = baseModules ++ guiModules ++ lanzabooteModule ++ [{
                            home-manager.useGlobalPkgs = false;
                            home-manager.useUserPackages = true;
                            home-manager.extraSpecialArgs = specialArgs;
                            home-manager.backupFileExtension = "backup";
                            home-manager.users.${username} = import ./nixos/home.nix;
                        }];
                    };

            # Home Manager standalone configuration builder function (for Arch Linux, etc.)
            mkHomeManagerConfiguration = hostname: hostAttrs:
                let
                    system = hostAttrs.system;
                    username = getUsernameForHost hostname hostAttrs;
                    pkgs = import nixpkgs { inherit system; };
                    specialArgs = {
                        inherit inputs username hostname;
                        enableGui = hostAttrs.enableGui;
                        hostSpecificHomeConfig = hostAttrs.hostSpecificHomeConfig or null;
                    };
                in home-manager.lib.homeManagerConfiguration {
                        inherit pkgs;
                        modules = [ ./home.nix ];
                        extraSpecialArgs = specialArgs;
                    };

            # Classify hosts based on enableSystem flag
            nixosHosts =
                nixpkgs.lib.filterAttrs (name: attrs: attrs.enableSystem) myHosts;
            homeManagerHosts =
                nixpkgs.lib.filterAttrs (name: attrs: !attrs.enableSystem) myHosts;

        in {
            # NixOS configurations (enableSystem = true)
            nixosConfigurations = nixpkgs.lib.mapAttrs mkNixosSystem nixosHosts;

            # Home Manager standalone configurations (enableSystem = false, for Arch Linux, etc.)
            # Username can be specified via NIX_USERNAME environment variable
            # Usage:
            #   home-manager switch --flake .#X1C10  (uses default username: yutkat)
            #   NIX_USERNAME=kat home-manager switch --flake .#X1C10 --impure  (uses kat)
            homeConfigurations = nixpkgs.lib.mapAttrs' (hostname: hostAttrs:
                nixpkgs.lib.nameValuePair hostname
                (mkHomeManagerConfiguration hostname hostAttrs)) homeManagerHosts;
        };
}
