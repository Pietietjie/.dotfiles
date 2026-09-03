{ config, pkgs, lib, ...}: 
let
  luksDeviceNames =
    builtins.attrNames
      ((import ./hardware.nix {
        inherit config lib pkgs;
        modulesPath = builtins.toString <nixpkgs/nixos/modules>;
      }).boot.initrd.luks.devices);
in {
  boot.kernelPackages = pkgs.linuxPackages_6_12;  # LTS kernel for NVIDIA compatibility

  boot.initrd.luks.devices = lib.genAttrs luksDeviceNames (_: {
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  });

  boot.initrd.availableKernelModules = [ "tpm_tis" "tpm_crb" "tpm_tis_core" ];

  boot.kernelModules = [ "usbhid" "uhci_hcd" "ehci_hcd" "xhci_hcd" ];

  boot.initrd.systemd.enable = true;
}

