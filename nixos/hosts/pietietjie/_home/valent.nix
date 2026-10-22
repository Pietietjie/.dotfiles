{ lib, ... }:
let
    inherit (lib.hm.gvariant) mkArray mkDictionaryEntry mkVariant;

    pairedDevices = [
        "020de79bee614c9ab3832a18bbf32736"
    ];

    commands = {
        "22a599da-8080-4ff7-81d7-8e2c58c0aef9" = {
            name = "Shutdown";
            command = "systemctl poweroff";
        };
        "7eaa2401-0e29-4ca3-b139-6c3a05b3f9ed" = {
            name = "Reboot";
            command = "systemctl reboot";
        };
        "a526ed6a-97c0-4610-9903-beeae2bd0fe7" = {
            name = "Suspend";
            command = "systemctl suspend";
        };
        "f7ee3fda-0bd1-4f06-a784-b148e7f9f360" = {
            name = "Lock Screen";
            command = "noctalia-shell ipc call lockScreen lock";
        };
        "74c90cfc-e6b6-476c-838a-f00c93b3d6f6" = {
            name = "Log Out";
            command = "niri msg action quit --skip-confirmation";
        };
        "9ef840ed-5ec6-4f9c-8c45-8c602cfda27d" = {
            name = "Monitors Off";
            command = "niri msg action power-off-monitors";
        };
        "f81cbd0f-1e50-46dc-92b8-505eac3036ca" = {
            name = "Play/Pause";
            command = "noctalia-shell ipc call media playPause";
        };
        "3ca45331-c292-460b-a8d2-5760aafac23c" = {
            name = "Mute Output";
            command = "noctalia-shell ipc call volume muteOutput";
        };
        "70384760-c497-493b-8e48-591e26c31ab7" = {
            name = "Screenshot";
            command = "niri msg action screenshot-screen";
        };
        "22828f62-cbda-48d0-94a8-516f63463646" = {
            name = "Sync Notes";
            command = "systemctl --user start notes-sync";
        };
        "6edbeb09-bbd4-4d00-9a5b-943159c6c69b" = {
            name = "Sync Passwords";
            command = "systemctl --user start rclone-passwords";
        };
    };

    mkCommand = uuid: { name, command }:
        mkDictionaryEntry [
            uuid
            (mkVariant (mkArray "{sv}" [
                (mkDictionaryEntry [ "name" (mkVariant name) ])
                (mkDictionaryEntry [ "command" (mkVariant command) ])
            ]))
        ];

    commandList = mkArray "{sv}" (lib.mapAttrsToList mkCommand commands);

    runcommandSettings = device:
        lib.nameValuePair "ca/andyholmes/valent/device/${device}/plugin/runcommand" {
            enabled = true;
            commands = commandList;
        };
in {
    dconf.settings = lib.listToAttrs (map runcommandSettings pairedDevices);
}
