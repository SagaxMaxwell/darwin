{ config, pkgs, ... }:

{
  home = {
    stateVersion = "24.05";

    packages = with pkgs; [
      # Nix tooling.
      nix-output-monitor
      nix-tree
      nixd
      nixfmt

      # Command-line tools.
      xh

      # Development environments.
      rustup

      # GUI apps.
      chatgpt
      google-chrome
      ghostty-bin
    ];
  };

  programs = {
    # Shells.
    bash = {
      enable = true;
    };

    fish = {
      enable = true;
    };

    nushell = {
      enable = true;
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
    };

    # Shell environment.
    direnv = {
      enable = true;

      nix-direnv = {
        enable = true;
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    # Command-line tools.
    bat = {
      enable = true;
    };

    eza = {
      enable = true;
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    tealdeer = {
      enable = true;
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    # Development tools.
    bun = {
      enable = true;
    };

    codex = {
      enable = true;
    };

    git = {
      enable = true;

      settings.user = {
        name = "Maxwell";
        email = "sagax.maxwell@gmail.com";
      };
    };

    home-manager = {
      enable = true;
    };

    nix-index = {
      enable = true;
    };

    nix-index-database = {
      comma = {
        enable = true;
      };
    };

    uv = {
      enable = true;
    };

    # Editors.
    helix = {
      enable = true;
    };

    vscode = {
      enable = true;
    };

    # GUI apps.
    obsidian = {
      enable = true;
    };
  };

  # Expose GUI apps to Spotlight.
  targets.darwin = {
    linkApps = {
      enable = false;
    };

    copyApps = {
      enable = true;
    };
  };

  xdg = {
    enable = true;

    configFile = {
      "helix/config.toml" = {
        source = ./helix/config.toml;
        force = true;
      };
    };
  };
}
