{ pkgs, username, ... }: {
  hardware.keyboard.zsa.enable = true;
  users.users.${username}.extraGroups = [ "plugdev" ];
  environment.systemPackages = with pkgs; [
    keymapp
  ];
}
