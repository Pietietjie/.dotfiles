{
    description = "NixOS Flake Configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; # Or use nixos-24.11 etc.

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

    outputs = { self, nixpkgs, lanzaboote, ... }@inputs: {
        nixosConfigurations = {
            # "nixos" should match networking.hostName
            nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    lanzaboote.nixosModules.lanzaboote
                    ./nixos/noctalia.nix
                    ./nixos/hosts/pietietjie/configuration.nix
                ];
            };
        };
    };
}
