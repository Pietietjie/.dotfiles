# Strip group/other permissions from credential stores and shell histories
{ username, homeDir ? "/home/${username}", ... }:
let
    sensitivePaths = [
        ".ssh"
        ".gnupg"
        ".docker"
        ".aws"
        ".netrc"
        ".npmrc"
        ".pgpass"
        ".my.cnf"
        ".path"
        ".claude"
        ".claude.json"
        ".bash_history"
        ".python_history"
        ".zsh_history"
        ".config/gh"
        ".config/composer/auth.json"
        ".local/share/keyrings"
        ".claude.json.backup.*"
        ".zsh_history.*"
        ".bash_history.*"
    ];
in {
    systemd.tmpfiles.rules = map (path: "Z ${homeDir}/${path} ~0700 - - -") sensitivePaths;
}
