{
  config,
  gitUserEmail,
  gitUserName,
  pkgs,
  ...
}:

{
  home = {
    stateVersion = "24.05";

    packages = with pkgs; [
      source-han-sans
      source-han-serif
      source-han-mono
      lxgw-wenkai
      ibm-plex
      nerd-fonts.jetbrains-mono
      rustup
      xh
      nixd
      nixfmt
      chatgpt
      nix-tree
      nix-output-monitor
    ];
  };

  programs = {
    bat = {
      enable = true;
    };

    bun = {
      enable = true;
    };

    codex = {
      enable = true;
    };

    command-not-found = {
      enable = false;
    };

    direnv = {
      enable = true;

      nix-direnv = {
        enable = true;
      };
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

    # Uses the Git identity placeholders from flake.nix.
    git = {
      enable = true;

      settings.user = {
        name = gitUserName;
        email = gitUserEmail;
      };
    };

    helix = {
      enable = true;
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

    nushell = {
      enable = true;
    };

    obsidian = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    tealdeer = {
      enable = true;
    };

    uv = {
      enable = true;
    };

    vscode = {
      enable = true;
    };

    wezterm = {
      enable = true;
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
    };
  };

  # Copy Home Manager GUI apps into ~/Applications for Spotlight.
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
  };
}
