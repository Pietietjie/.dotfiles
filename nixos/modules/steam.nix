{ ... }: {
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamemode.enable = true;
    coolercontrol.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

}
