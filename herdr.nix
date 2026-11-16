{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.herdr;

  # Herdr ships its hook scripts in the source tree; link them as they are.
  script = agent: "${cfg.package.src}/src/integration/assets/${agent}/herdr-agent-state.sh";

  # Hook entry at the path where Herdr looks for its integration.
  hook = path: {
    type = "command";
    command = "bash '${config.home.homeDirectory}/${path}' session";
    timeout = 10;
  };

  enabled = agent: cfg.enable && lib.elem agent cfg.integrations;
in
{
  options.programs.herdr.integrations = lib.mkOption {
    type = lib.types.listOf (
      lib.types.enum [
        "claude"
        "codex"
      ]
    );
    default = [ ];
    example = [ "claude" ];
    description = ''
      Agents that report their session to Herdr, so that
      `session.resume_agents_on_restore` can resume them.
    '';
  };

  config = lib.mkMerge [
    {
      programs.herdr = {
        enable = true;
        mutableSettings = true;
        integrations = [
          "claude"
          "codex"
        ];
        settings = {
          theme.auto_switch = true;
          session.resume_agents_on_restore = true;
          remote.manage_ssh_config = true;
          terminal.default_shell = "nu";

          # Forward pane images out to the Ghostty outer terminal.
          terminal.kitty_graphics = true;
          worktrees.directory = "~/.herdr/worktrees";
          ui.toast.delivery = "herdr";
          ui.toast.delay_seconds = 0;
          ui.sound.enabled = true;
          experimental.pane_history = true;
        };
      };
    }

    (lib.mkIf (enabled "claude") {
      programs.claude-code = {
        hooks."herdr-agent-state.sh" = script "claude";
        settings.hooks.SessionStart = [
          {
            matcher = "^(startup|resume|clear|compact|fork)$";
            hooks = [ (hook ".claude/hooks/herdr-agent-state.sh") ];
          }
        ];
      };
    })

    (lib.mkIf (enabled "codex") {
      home.file.".codex/herdr-agent-state.sh".source = script "codex";

      programs.codex = {
        settings.features.hooks = true;
        hooks.SessionStart = [ { hooks = [ (hook ".codex/herdr-agent-state.sh") ]; } ];
      };
    })
  ];
}
