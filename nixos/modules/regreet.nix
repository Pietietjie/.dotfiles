{ lib, ... }: {
  programs.regreet = {
    enable = true;
    cageArgs = [ "-m" "last" ];
    settings = {
      GTK.theme_name = lib.mkForce "Tokyonight-Dark";
    };
  };
  services.greetd.enable = true;
}
