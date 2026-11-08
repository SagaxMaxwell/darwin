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
    helix = {
      enable = true;

      settings = {
        theme = "onedark";

        editor = {
          "true-color" = true;
          "line-number" = "relative";
          cursorline = true;

          "end-of-line-diagnostics" = "hint";
          "inline-diagnostics" = {
            "cursor-line" = "warning";
          };

          statusline = {
            right = [
              "diagnostics"
              "separator"
              "selections"
              "register"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
            separator = "💤";

            mode = {
              normal = "🦄";
              insert = "🐣";
              select = "🐧";
            };
          };

          lsp = {
            "display-inlay-hints" = true;
          };

          "cursor-shape" = {
            insert = "bar";
            select = "underline";
          };

          "file-picker" = {
            hidden = false;
          };

          gutters = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];

          "soft-wrap" = {
            enable = true;
            "wrap-indicator" = "";
          };
        };
      };

      languages.language = [
        {
          name = "nix";
          "auto-format" = true;
          "language-servers" = [ "nixd" ];
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "c-sharp";
          "language-servers" = [ "roslyn" ];
        }
      ];

      languages.language-server.roslyn = {
        command = "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer";
        args = [ "--stdio" ];
      };

      languages.language-server.ty = {
        command = "${pkgs.ty}/bin/ty";
        args = [ "server" ];
      };

      languages.language-server.ruff = {
        command = "${pkgs.ruff}/bin/ruff";
        args = [ "server" ];
      };

      languages.language-server.rust-analyzer.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    };

    zed-editor = {
      enable = true;
      userSettings.auto_install_extensions = {
        csharp = true;
        nix = true;
        oxc = true;
        tombi = true;
        toml = false;
        github-theme = false;
      };
      userSettings.diagnostics.inline.enabled = true;
      userSettings.autosave = "on_window_change";
      userSettings.format_on_save = "on";
      userSettings.lsp.nixd.binary.path = "${pkgs.nixd}/bin/nixd";
      userSettings.lsp.oxfmt.binary = {
        path = "${pkgs.oxfmt}/bin/oxfmt";
        arguments = [ "--lsp" ];
      };
      userSettings.lsp.oxlint.initialization_options.settings.fixKind = "safe_fix";
      userSettings.languages.JavaScript = {
        code_actions_on_format = {
          "source.organizeImports" = true;
          "source.fixAll.oxc" = true;
        };
      };
      userSettings.languages.JSX = {
        code_actions_on_format = {
          "source.organizeImports" = true;
          "source.fixAll.oxc" = true;
        };
      };
      userSettings.languages.TypeScript = {
        code_actions_on_format = {
          "source.organizeImports" = true;
          "source.fixAll.oxc" = true;
        };
      };
      userSettings.languages.TSX = {
        code_actions_on_format = {
          "source.organizeImports" = true;
          "source.fixAll.oxc" = true;
        };
      };
      userSettings.languages.Nix = {
        language_servers = [ "nixd" ];
        formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
      };
      userSettings.languages.TOML = {
        language_servers = [ "tombi" ];
        formatter.language_server.name = "tombi";
      };
      userSettings.languages.CSharp = {
        code_actions_on_format."source.organizeImports" = true;
        formatter.external = {
          command = "${pkgs.csharpier}/bin/csharpier";
          arguments = [
            "format"
            "--write-stdout"
          ];
        };
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
      cli.enable = true;

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
