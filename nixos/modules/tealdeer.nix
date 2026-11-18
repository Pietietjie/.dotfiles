{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    tealdeer
  ];

  systemd.user.services.tealdeer-update = {
    description = "Refresh the tldr page cache";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.tealdeer}/bin/tldr --update";
    };
  };

  systemd.user.timers.tealdeer-update = {
    description = "Refresh the tldr page cache weekly";
    timerConfig = {
      OnCalendar = "weekly";
      OnStartupSec = "1min";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
    wantedBy = [ "timers.target" ];
  };
}
