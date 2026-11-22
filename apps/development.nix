{ pkgs, ... }:

{
  imports = [ ./herdr.nix ];

  # Use Herdr for Gas City and its supervisor.
  home.sessionVariables = {
    GC_SESSION = "herdr";
    GC_SUPERVISOR_ENV = "GC_SESSION";
  };

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
      settings.theme = "auto";
    };

    codex = {
      enable = true;
      mutableSettings = true;
    };

    pi-coding-agent = {
      enable = true;
      mutableSettings = true;
      settings.theme = "system";
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

      settings.rerere.enabled = true;
      settings.user = {
        name = "maxwellsagax";
        email = "sagax.maxwell@gmail.com";
      };
    };

    uv.enable = true;
  };
}
