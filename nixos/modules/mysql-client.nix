{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mariadb.client
  ];
}
