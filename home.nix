{
  pkgs,
  ...
}:

{
  imports = [
    ./modules/omniwm
  ];

  home = {
    stateVersion = "26.11";

    packages = with pkgs; [
      # Nix tooling.
      nix-output-monitor
      nix-tree
      nixd
      nixfmt

      # Command-line tools.
      gh
      oxfmt
      xh

      # Development environments.
      dotnet-sdk_10
      rustup

      # GUI apps.
      blender
      chatgpt
      shottr
      tabularis
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

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    # Command-line tools.
    bat.enable = true;

    eza.enable = true;

    man.generateCaches = false;

    fd.enable = true;

    ripgrep.enable = true;

    tealdeer.enable = true;

    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
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
    bun.enable = true;

    codex.enable = true;

    delta.enable = true;

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

    home-manager.enable = true;

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;

      settings.theme = "Atom One Dark";
    };

    nix-index.enable = true;

    nix-index-database = {
      comma.enable = true;
    };

    uv.enable = true;

    # Editors.
    zed-editor = {
      enable = true;
      extensions = [
        "csharp"
        "github-theme"
        "nix"
        "oxc"
        "tombi"
      ];
      userSettings.diagnostics.inline.enabled = true;
      userSettings.autosave = "on_window_change";
      userSettings.format_on_save = "on";
      userSettings.languages.Nix = {
        language_servers = [ "nixd" ];
        formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
      };
      userSettings.lsp.nixd.binary.path = "${pkgs.nixd}/bin/nixd";
      userSettings.lsp.oxlint.initialization_options.settings.fixKind = "safe_fix";
      userSettings.languages.JavaScript.code_actions_on_format = {
        "source.organizeImports" = true;
        "source.fixAll.oxc" = true;
      };
      userSettings.languages.JSX.code_actions_on_format = {
        "source.organizeImports" = true;
        "source.fixAll.oxc" = true;
      };
      userSettings.languages.TypeScript.code_actions_on_format = {
        "source.organizeImports" = true;
        "source.fixAll.oxc" = true;
      };
      userSettings.languages.TSX.code_actions_on_format = {
        "source.organizeImports" = true;
        "source.fixAll.oxc" = true;
      };
      userSettings.languages.CSharp.code_actions_on_format."source.organizeImports" = true;
      userSettings.languages.CSharp.formatter.external = {
        command = "${pkgs.csharpier}/bin/csharpier";
        arguments = [
          "format"
          "--write-stdout"
        ];
      };
      userSettings.languages.Python = {
        language_servers = [
          "ty"
          "ruff"
        ];
        code_actions_on_format."source.fixAll.ruff" = true;
      };
    };

    # GUI apps.
    obsidian = {
      enable = true;

      vaults.Documents = {
        target = "Documents";
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
        jupyter-notebook
        advanced-canvas
        tldraw
      ];

      defaultSettings.themes = [ pkgs.obsidianThemes.border ];
    };

    google-chrome = {
      enable = true;

      extensions = [
        "bgnkhhnnamicmpeenaelnjfhikgbkllg" # AdGuard AdBlocker
      ];
    };
  };

  xdg.enable = true;
}
