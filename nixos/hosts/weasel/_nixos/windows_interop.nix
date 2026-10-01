{ pkgs, ... }:
let
  winExe = name: path: pkgs.writeShellScriptBin name ''
    export WSL_UTF8=1
    exec "${path}" "$@"
  '';
in
{
  environment.systemPackages = [
    (winExe "wsl" "/mnt/c/Windows/System32/wsl.exe")
    (winExe "explorer" "/mnt/c/Windows/explorer.exe")
    (winExe "clip" "/mnt/c/Windows/System32/clip.exe")
    (winExe "powershell" "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
    (winExe "cmd" "/mnt/c/Windows/System32/cmd.exe")
  ];
}
