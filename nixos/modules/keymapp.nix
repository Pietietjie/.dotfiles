{ pkgs, ... }: {
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="3297", ENV{ID_MODEL_ID}=="4975", MODE="0666"
  '';
  environment.systemPackages = with pkgs; [
    keymapp
  ];
}
