{ pkgs, username, homeDir ? "/home/${username}", ... }:
let
  projectDir = "${homeDir}/proj";
  dotfilesPath = "${homeDir}/.dotfiles";
  stateVersion = "26.05";
in {
  environment.systemPackages = with pkgs; [
    claude-code
  ];

  users.groups.devshare = { };

  users.users.claude = {
    isNormalUser = true;
    description = "Sandboxed Claude Code user";
    extraGroups = [ "devshare" ];
    hashedPassword = "!";# no password login; reach it via sudo/machinectl
    homeMode = "700";
  };

  users.users.${username} = {
    extraGroups = [ "devshare" ];
    homeMode = "710";
  };

  # Shared project directory, setgid so new files keep the group
  systemd.tmpfiles.rules = [
    "z ${homeDir} 0710 ${username} devshare -"
    "d ${projectDir} 2770 ${username} devshare -"
  ];

  # Enforce Claude Code's sandbox as policy the claude user can't override
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    sandbox = {
      enabled = true;
      failIfUnavailable = true;
    };
  };

  home-manager.users.claude = { pkgs, config, ... }: {
    home.stateVersion = stateVersion;

    home.packages = with pkgs; [
      claude-code
      bubblewrap   # sandbox filesystem isolation
      socat        # sandbox network proxy
      git
      ripgrep
    ];

    home.sessionVariables.CLAUDE_PROJECT_DIR = projectDir;

    programs.git = {
      enable = true;
      userName = "Pieter";
      userEmail = "21083972+Pietietjie@users.noreply.github.com";
      settings = {
        safe.directory = [ "${projectDir}/*" ];
        init.defaultBranch = "main";
      };
    };

    # Claude Code config
    home.file.".claude/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/claude/settings.json";
        force = true;
    };

    home.file.".claude/CLAUDE.md" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/claude/CLAUDE.md";
        force = true;
    };
  };
}
