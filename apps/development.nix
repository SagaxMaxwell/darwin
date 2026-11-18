{ pkgs, ... }:

{
  imports = [ ./herdr.nix ];

  home.packages = with pkgs; [
    nixd
    nixfmt
    gh
    oxfmt
    ruff
    ty
    rustup
  ];

  programs = {

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

    uv.enable = true;
  };
}
