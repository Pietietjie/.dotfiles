{...}: {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig."50-hdmi-volume" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_output.*hdmi.*"; }
          ];
          actions = {
            update-props = {
              "state.default-volume" = 0.2;
              "state.restore-volume" = false;
            };
          };
        }
      ];
    };
  };
}
