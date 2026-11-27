{ lib, pkgs, ... }:

{
  imports = [ ./herdr.nix ];

  # Use Herdr for Gas City and its supervisor.
  home.sessionVariables = {
    GC_SESSION = "herdr";
    GC_SUPERVISOR_ENV = "GC_SESSION";
  };

  home.packages = [
    pkgs.nixd
    pkgs.tix
    pkgs.nixfmt
    pkgs.gh
    pkgs.oxfmt
    pkgs.ruff
    pkgs.ty
    pkgs.rustup
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
      settings = {
        theme = "system";
        defaultProvider = "openrouter";
        defaultModel = "openrouter/free";
        shellPath = lib.getExe' pkgs.bash "bash";
        externalEditor = lib.getExe' pkgs.helix "hx";
        defaultTools = [ "+codemode" ];
        npmCommand = [ (lib.getExe' pkgs.bun "bun") ];
        packages = [
          "npm:billion-context"
          "npm:pi-total-recall"
          "npm:pi-lens"
          "npm:@tintinweb/pi-subagents"
          "npm:pi-web-access"
          "npm:pi-doc-review"
          "npm:@juicesharp/rpiv-todo"
          "npm:pi-md-render"
        ];
        terminal.showTerminalProgress = true;
        quietStartup = "header";
      };
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

      settings = {
        rerere.enabled = true;
        fetch.prune = true;
        merge.conflictStyle = "zdiff3";
        push.autoSetupRemote = true;
        user = {
          name = "maxwellsagax";
          email = "sagax.maxwell@gmail.com";
        };
      };
    };

    uv.enable = true;
  };
}
