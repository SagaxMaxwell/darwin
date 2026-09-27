{
  pkgs,
  ...
}:

{
  home = {
    stateVersion = "26.11";

    packages = with pkgs; [
      # Nix tooling.
      nix-output-monitor
      nix-tree
      nixd
      nixfmt

      # Command-line tools.
      oxfmt
      xh

      # Development environments.
      dotnet-sdk_10
      rustup
      (godot-mono.overrideAttrs {
        dotnet-sdk = pkgs.dotnet-sdk_10;
      })

      # GUI apps.
      blender
      chatgpt
      shottr
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
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
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

    man = {
      generateCaches = false;
    };

    fd = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    tealdeer = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
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

    delta = {
      enable = true;
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

    home-manager = {
      enable = true;
    };

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;

      settings = {
        theme = "Atom One Dark";
      };
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
              normal = "🥳";
              insert = "🤯";
              select = "🤔";
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

    vscode = {
      enable = true;

      profiles.default.extensions = with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
        analytic-signal.preview-pdf
        charliermarsh.ruff
        csharpier.csharpier-vscode
        github.github-vscode-theme
        ms-python.debugpy
        ms-python.isort
        ms-python.python
        ms-python.vscode-python-envs
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-dotnettools.csharp
        # Oxc's current releases are universal; platform-specific builds are older.
        pkgs.nix-vscode-extensions.vscode-marketplace-release-universal.oxc.oxc-vscode
        rust-lang.rust-analyzer
      ];
    };

    # GUI apps.
    obsidian = {
      enable = true;

      defaultSettings.communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-linter
        templater-obsidian
        dataview
        homepage
        notebook-navigator
        advanced-canvas
        tldraw
      ];
    };

    google-chrome = {
      enable = true;

      extensions = [
        "bgnkhhnnamicmpeenaelnjfhikgbkllg" # AdGuard AdBlocker
      ];
    };
  };

  xdg = {
    enable = true;
  };
}
