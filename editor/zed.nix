{
  alpha,
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;

    # Install the app through Homebrew.
    package = null;

    userSettings.theme = {
      mode = "system";
      light = "GitHub Dark Dimmed";
      dark = "IR Black";
    };

    userSettings.terminal = {
      font_family = "Cascadia Code NF";
      font_fallbacks = [
        "Maple Mono NF"
        "Maple Mono NF CN"
      ];
    };

    # Set outer surface opacity.
    userSettings.theme_overrides =
      lib.mapAttrs
        (
          _: background:
          {
            "background.appearance" = "blurred";
            inherit background;
            "title_bar.background" = background;
            "title_bar.inactive_background" = background;
            "status_bar.background" = background;
          }
          // lib.genAttrs [
            "editor.background"
            "editor.gutter.background"
            "panel.background"
            "terminal.background"
            "toolbar.background"
            "tab_bar.background"
            "tab.active_background"
            "tab.inactive_background"
          ] (_: "#00000000")
        )
        {
          "GitHub Dark Dimmed" = "#212830${alpha}";
          "IR Black" = "#000000${alpha}";
        };
    userSettings.auto_install_extensions = {
      github-theme = true;
      ir-black = true;
      nix = true;
      oxc = true;
      tombi = true;
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
    userSettings.lsp.oxlint.binary = {
      path = "${pkgs.oxlint}/bin/oxlint";
      arguments = [ "--lsp" ];
    };
    userSettings.lsp.ruff.binary = {
      path = "${pkgs.ruff}/bin/ruff";
      arguments = [ "server" ];
    };
    userSettings.lsp.ty.binary = {
      path = "${pkgs.ty}/bin/ty";
      arguments = [ "server" ];
    };
    userSettings.lsp.tombi.binary = {
      path = "${pkgs.tombi}/bin/tombi";
      arguments = [ "lsp" ];
    };
    userSettings.lsp.rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    userSettings.languages =
      lib.genAttrs [ "JavaScript" "JSX" "TypeScript" "TSX" ] (_: {
        formatter.language_server.name = "oxfmt";
        code_actions_on_format = {
          "source.organizeImports" = true;
          "source.fixAll.oxc" = true;
        };
      })
      // {
        Nix = {
          language_servers = [ "nixd" ];
          formatter.external.command = "${pkgs.nixfmt}/bin/nixfmt";
        };
        TOML = {
          language_servers = [ "tombi" ];
          formatter.language_server.name = "tombi";
        };
        Python = {
          language_servers = [
            "ty"
            "ruff"
          ];
          code_actions_on_format."source.fixAll.ruff" = true;
        };
      };
  };
}
