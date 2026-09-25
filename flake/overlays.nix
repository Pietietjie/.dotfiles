{ lib, ... }:
let
  customOverlay = final: prev: {
    im-emoji-picker = prev.libsForQt5.callPackage ../nixos/pkgs/im-emoji-picker.nix { };
    xwayland-satellite = prev.callPackage ../nixos/pkgs/xwayland-satellite.nix { };
  };
in
{
  flake.overlays.default = customOverlay;
  flake.modules.nixos._overlay = { ... }: {
    nixpkgs.overlays = [ customOverlay ];
  };
}
