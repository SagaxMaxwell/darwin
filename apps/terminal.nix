{ pkgs, opacity, ... }:

{

  # Expose the bundled Ghostty CLI.
  home.sessionPath = [ "/Applications/Ghostty.app/Contents/MacOS" ];

  home.packages = with pkgs; [
    nix-output-monitor
    nix-tree
    xh
    wireguard-tools
  ];

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
  };
}
