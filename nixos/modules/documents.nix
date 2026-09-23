{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libreoffice
    kdePackages.okular
  ];
}
