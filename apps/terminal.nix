{
  inputs,
  pkgs,
  opacity,
  terminalFonts,
  ...
}:

{

  # Expose the bundled Ghostty CLI.
  home.sessionPath = [ "/Applications/Ghostty.app/Contents/MacOS" ];

  home.packages = with pkgs; [
    nix-output-monitor
    nix-tree
    broot
    ast-grep
    fd
    mcat
    resterm
    ripgrep
    sendme
    zstd
    wireguard-tools
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs
  ];

  programs = {

    # Shells.
    bash.enable = true;

    fish.enable = true;

    nushell = {
      enable = true;
      loadSessionVariables = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Shell environment.
    devenv = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship.enable = true;

    # Command-line tools.
    tealdeer.enable = true;

    atuin.enable = true;

    bottom = {
      enable = true;
      settings.styles = {
        widgets = {
          text = "reset";
          widget_title = "reset";
          border_color = "reset";
        };
        graphs = {
          graph_color = "reset";
          legend_text = "reset";
        };
      };
    };

    yazi.enable = true;

    zoxide.enable = true;

    ghostty = {
      enable = true;

      # Install the app through Homebrew.
      package = null;

      settings = {
        font-family = terminalFonts;
        theme = "light:GitHub Dark Dimmed,dark:IR Black";
        background-opacity = opacity;
        background-opacity-cells = true;
        background-blur = true;
      };
    };

  };
}
