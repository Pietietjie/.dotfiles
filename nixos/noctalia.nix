{ pkgs, inputs, ... }:
{
    # install package
    environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        # ... maybe other stuff
    ];
    imports = [
        inputs.noctalia.nixosModules.default
    ];
    services.noctalia-shell.enable = true;
}
