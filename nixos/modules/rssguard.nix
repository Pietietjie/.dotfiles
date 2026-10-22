{ pkgs, lib, inputs, ... }:
let
    subscriptions = import "${inputs.secrets}/subscriptions.nix";

    isChannelId = id: builtins.match "UC[A-Za-z0-9_-]{22}" id != null;

    renderFeed = title: id:
        assert lib.assertMsg (isChannelId id)
            "rssguard: ${title} has an invalid YouTube channel id: ${id}";
        let label = lib.escapeXML title;
        in "      " + ''<outline type="rss" text="${label}" title="${label}" xmlUrl="https://www.youtube.com/feeds/videos.xml?channel_id=${id}" htmlUrl="https://www.youtube.com/channel/${id}"/>'';

    renderCategory = { name, channels }:
        let label = lib.escapeXML name;
        in lib.concatStringsSep "\n" (
            [ ("    " + ''<outline text="${label}" title="${label}">'') ]
            ++ lib.mapAttrsToList renderFeed channels
            ++ [ "    </outline>" ]
        );

    youtubeChannelsOpml = pkgs.writeText "youtube-channels-rssguard.opml" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
          <head>
            <title>YouTube Subscriptions</title>
          </head>
          <body>
        ${lib.concatMapStringsSep "\n" renderCategory subscriptions}
          </body>
        </opml>
    '';

    rssguard-opml = pkgs.writeShellApplication {
        name = "rssguard-opml";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
            destination="''${1:-$HOME/youtube-channels-rssguard.opml}"

            if [ "$destination" = "-" ]; then
                cat ${youtubeChannelsOpml}
                exit 0
            fi

            install -m 644 ${youtubeChannelsOpml} "$destination"

            echo "Wrote $destination"
            echo "Import with: RSS Guard -> File -> Import feeds -> OPML 2.0"
        '';
    };
in {
    environment.systemPackages = [
        pkgs.rssguard
        rssguard-opml
    ];
}
