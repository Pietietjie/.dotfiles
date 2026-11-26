{ pkgs, username, homeDir ? "/home/${username}", ... }:
let
  projectDir = "${homeDir}/proj";
  dotfilesPath = "${homeDir}/.dotfiles";
  # stateVersion = "26.05";
in {
  environment.systemPackages = with pkgs; [
    claude-code
  ];

  users.groups.devshare = { };

  users.users.claude = {
    isNormalUser = true;
    description = "Sandboxed Claude Code user";
    hashedPassword = "!";# no password login; reach it via sudo/machinectl
    homeMode = "700";
  };

  users.users.${username} = {
    homeMode = "710";
  };

  systemd.tmpfiles.rules = [
    "z ${homeDir} 0710 ${username} devshare -"
    "a+ ${homeDir} - - - - user:claude:--x"

    "d ${projectDir} 2770 ${username} devshare -"
    "A+ ${projectDir} - - - - user:claude:rwX,user:${username}:rwX,default:user:claude:rwX,default:user:${username}:rwX,default:group::---"

    "z ${dotfilesPath} 2770 ${username} devshare -"
    "A+ ${dotfilesPath} - - - - user:claude:rwX,user:${username}:rwX,default:user:claude:rwX,default:user:${username}:rwX,default:group::---"
  ];

  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    sandbox = {
      enabled = true;
      failIfUnavailable = true;
    };
  };

  home-manager.users.claude = { pkgs, config, ... }: {
    # home.stateVersion = stateVersion;

    home.packages = with pkgs; [
      bubblewrap   # sandbox filesystem isolation
      socat        # sandbox network proxy
      git
      ripgrep
    ];

    home.sessionVariables.CLAUDE_PROJECT_DIR = projectDir;

    # .zshrc exports dot="$HOME/.dotfiles"; point it at the real repo
    home.file.".dotfiles".source = config.lib.file.mkOutOfStoreSymlink dotfilesPath;

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Pieter";
          email = "21083972+Pietietjie@users.noreply.github.com";
        };
        safe.directory = [ "${projectDir}/*" "${dotfilesPath}" ];
        init.defaultBranch = "main";
      };
    };

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
