{
  lib,
  pkgs,
  opacity,
  alpha,
  ...
}:

{
  imports = [
    ./helix.nix
    ./herdr.nix
    ./rift.nix
    ./zed.nix
  ];

  home = {
    stateVersion = "26.11";

    # Expose the bundled Ghostty CLI.
    sessionPath = [ "/Applications/Ghostty.app/Contents/MacOS" ];

    packages = with pkgs; [

      # Nix tooling.
      nix-output-monitor
      nix-tree
      nixd
      nixfmt

      # Command-line tools.
      gh
      oxfmt
      ruff
      ty
      xh
      wireguard-tools

      # Development environments.
      rustup
    ];
  };

  programs = {

    # Shells.
    bash.enable = true;

    fish.enable = true;

    nushell.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Shell environment.
    direnv = {
      enable = true;

      nix-direnv.enable = true;
    };

    starship.enable = true;

    # Command-line tools.
    bat.enable = true;

    eza.enable = true;

    fd.enable = true;

    ripgrep.enable = true;

    tealdeer.enable = true;

    atuin.enable = true;

    yazi.enable = true;

    zoxide.enable = true;

    # Development tools.
    bun.enable = true;

    claude-code = {
      enable = true;
      mutableSettings = true;
    };

    codex = {
      enable = true;
      mutableSettings = true;
    };

    difftastic = {
      enable = true;
      git = {
        enable = true;
        mode = "difftool";
      };
    };

    git = {
      enable = true;

      settings.user = {
        name = "maxwellsagax";
        email = "sagax.maxwell@gmail.com";
      };
    };

    ghostty = {
      enable = true;

      # Install the app through Homebrew.
      package = null;

      settings = {
        theme = "light:TokyoNight Storm,dark:IR Black";
        background-opacity = opacity;
        background-opacity-cells = true;
        background-blur = true;
      };
    };

    nix-index-database = {
      comma.enable = true;
    };

    uv.enable = true;

    # GUI apps.
    mpv = {
      enable = true;
      config = {
        hwdec = "auto";
        background-color = "#${alpha}000000";
      };
    };

    obsidian = {
      enable = true;
      package = null;
      cli.enable = true;

      vaults.notes = {
        target = "Documents/notes";
        settings.app.restrictedMode = false;
      };

      defaultSettings.communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-linter
        {
          pkg = update-time;
          settings = {
            createdPropertyName = "date created";
            updatedPropertyName = "date updated";
          };
        }
        templater-obsidian
        dataview
        notebook-navigator
        jupyter-viewer
        advanced-canvas
        tldraw
      ];

      defaultSettings.themes = [ pkgs.obsidianThemes.border ];
    };

    google-chrome = {
      enable = true;
      package = null;

      extensions = [

        # AdGuard AdBlocker.
        "bgnkhhnnamicmpeenaelnjfhikgbkllg"
      ];
    };
  };

  launchd.agents =
    lib.mapAttrs
      (_: args: {
        enable = true;
        domain = "gui";
        config = {
          ProgramArguments = [ "/usr/bin/open" ] ++ args;
          RunAtLoad = true;
          LimitLoadToSessionType = "Aqua";
        };
      })
      {
        adguard-mini = [
          "-g"
          "-a"
          "/Applications/AdGuard Mini.app"
        ];
        chrome = [
          "-a"
          "/Applications/Google Chrome.app"
        ];
        ghostty = [
          "-a"
          "/Applications/Ghostty.app"
        ];
        quantumult-x = [
          "-a"
          "/Applications/Quantumult X.app"
        ];
        shottr = [
          "-g"
          "-a"
          "/Applications/Shottr.app"
        ];
      };

  xdg.enable = true;
}
