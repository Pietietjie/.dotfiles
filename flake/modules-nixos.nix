{ lib, ... }:
let
  dir = ../nixos/modules;
  entries = builtins.readDir dir;
  isNixFile = name: type:
    type == "regular" && lib.hasSuffix ".nix" name && !(lib.hasPrefix "_" name);
  nixFiles = lib.filterAttrs isNixFile entries;
  mkModule = fileName: _:
    lib.nameValuePair
      (lib.removeSuffix ".nix" fileName)
      (import (dir + "/${fileName}"));
in
{
  flake.modules.nixos = lib.mapAttrs' mkModule nixFiles;
}
