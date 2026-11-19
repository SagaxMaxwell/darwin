{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "base16_terminal";

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
        name = "python";
        "language-servers" = [
          "ty"
          "ruff"
        ];
      }
      {
        name = "toml";
        "language-servers" = [ "tombi" ];
      }
    ];

    languages.language-server.nixd.command = "${pkgs.nixd}/bin/nixd";

    languages.language-server.ty.command = "${pkgs.ty}/bin/ty";

    languages.language-server.ruff.command = "${pkgs.ruff}/bin/ruff";

    languages.language-server.tombi.command = "${pkgs.tombi}/bin/tombi";
  };
}
