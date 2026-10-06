{ config, lib, pkgs, ... }:
let
  cfg = config.programs.wallpaper-engine;

  niriBin = "${config.programs.niri.package}/bin/niri";

  enabledOutputs = pkgs.writeShellScript "wallpaper-engine-outputs" ''
    set -euo pipefail
    ${niriBin} msg --json outputs \
      | ${pkgs.jq}/bin/jq -r 'to_entries | map(select(.value.logical != null) | .key) | sort | join(" ")'
  '';

  bgCase = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (output: id: "    ${lib.escapeShellArg output}) echo ${lib.escapeShellArg id} ;;") cfg.wallpapers
  );

  audioFlags = if cfg.silent then [ "--silent" ] else [ "--volume" (toString cfg.volume) ];

  flags =
    [ "--fps" (toString cfg.fps) ]
    ++ audioFlags
    ++ lib.optionals (cfg.assetsDir != null) [ "--assets-dir" cfg.assetsDir ]
    ++ lib.optional (!cfg.pauseOnFullscreen) "--no-fullscreen-pause"
    ++ lib.optional cfg.disableMouse "--disable-mouse"
    ++ lib.optional cfg.disableParallax "--disable-parallax"
    ++ cfg.extraArgs;

  launcher = pkgs.writeShellScript "wallpaper-engine-start" ''
    set -euo pipefail

    bgFor () {
      case "$1" in
    ${bgCase}
        *) echo "" ;;
      esac
    }

    outputs=$(${enabledOutputs})

    if [ -z "$outputs" ]; then
      echo "wallpaper-engine: no enabled outputs" >&2
      exit 0
    fi

    args=()

    for output in $outputs; do
      args+=(--screen-root "$output")
      bg=$(bgFor "$output")
      if [ -n "$bg" ]; then
        args+=(--bg "$bg")
      fi
      args+=(--scaling ${cfg.scaling} --clamp ${cfg.clamp})
    done

    exec ${cfg.package}/bin/linux-wallpaperengine \
      ${lib.escapeShellArgs flags} \
      "''${args[@]}" \
      ${lib.optionalString (cfg.defaultWallpaper != null) (lib.escapeShellArg cfg.defaultWallpaper)}
  '';

  watcher = pkgs.writeShellScript "wallpaper-engine-watch" ''
    set -uo pipefail

    previous=""

    while :; do
      if current=$(${enabledOutputs} 2>/dev/null); then
        if [ "$current" != "$previous" ]; then
          if [ -n "$previous" ]; then
            ${pkgs.systemd}/bin/systemctl --user restart wallpaper-engine.service
          fi
          previous="$current"
        fi
      fi
      ${pkgs.coreutils}/bin/sleep ${toString cfg.pollInterval}
    done
  '';
in
{
  options.programs.wallpaper-engine = {
    enable = lib.mkEnableOption "linux-wallpaperengine as the niri desktop background";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.linux-wallpaperengine;
    };

    wallpapers = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = { HDMI-A-1 = "2317494988"; eDP-1 = "1108150151"; };
      description = "Workshop id (or absolute path) per output connector name.";
    };

    defaultWallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Workshop id used for outputs absent from `wallpapers`.";
    };

    assetsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/pietietjie/.steam/steam/steamapps/common/wallpaper_engine/assets";
      description = "Overrides the Steam auto-detection of Wallpaper Engine's assets.";
    };

    fps = lib.mkOption {
      type = lib.types.ints.positive;
      default = 30;
    };

    silent = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    volume = lib.mkOption {
      type = lib.types.ints.between 0 128;
      default = 15;
    };

    scaling = lib.mkOption {
      type = lib.types.enum [ "stretch" "fit" "fill" "default" ];
      default = "fill";
    };

    clamp = lib.mkOption {
      type = lib.types.enum [ "clamp" "border" "repeat" ];
      default = "border";
    };

    pauseOnFullscreen = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    disableMouse = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    disableParallax = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--disable-particles" ];
    };

    watchOutputs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Restarts the wallpaper when the set of enabled niri outputs changes, for
        example when kanshi switches between the docked and undocked profiles.
        Upstream does not handle wl_output removal, so a restart is required.
      '';
    };

    pollInterval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 5;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.programs.niri.enable;
        message = "programs.wallpaper-engine requires programs.niri.enable";
      }
      {
        assertion = cfg.defaultWallpaper != null || cfg.wallpapers != { };
        message = "programs.wallpaper-engine needs defaultWallpaper or at least one entry in wallpapers";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.user.services.wallpaper-engine = {
      description = "Wallpaper Engine backgrounds on the niri desktop";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      environment.XDG_SESSION_TYPE = "wayland";
      serviceConfig = {
        Type = "simple";
        ExecStart = launcher;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    systemd.user.services.wallpaper-engine-watch = lib.mkIf cfg.watchOutputs {
      description = "Restart Wallpaper Engine when the niri output layout changes";
      partOf = [ "graphical-session.target" ];
      after = [ "wallpaper-engine.service" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = watcher;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
