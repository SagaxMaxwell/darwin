{ config, ... }:

let
  cfg = config.programs.herdr;

  # Link upstream hook scripts.
  script = agent: "${cfg.package.src}/src/integration/assets/${agent}/herdr-agent-state.sh";

  # Report agent sessions to Herdr.
  hook = path: {
    type = "command";
    command = "bash '${config.home.homeDirectory}/${path}' session";
    timeout = 10;
  };

in
{
  programs.herdr = {
    enable = true;
    mutableSettings = true;
    settings = {
      theme.auto_switch = true;
      session.resume_agents_on_restore = true;
      remote.manage_ssh_config = true;
      terminal.default_shell = "nu";

      # Forward pane images to Ghostty.
      terminal.kitty_graphics = true;
      worktrees.directory = "~/.herdr/worktrees";
      ui.toast.delivery = "herdr";
      ui.toast.delay_seconds = 0;
      ui.sound.enabled = true;
      experimental.pane_history = true;
    };
  };

  programs.claude-code = {
    hooks."herdr-agent-state.sh" = script "claude";
    settings.hooks.SessionStart = [
      {
        matcher = "^(startup|resume|clear|compact|fork)$";
        hooks = [ (hook ".claude/hooks/herdr-agent-state.sh") ];
      }
    ];
  };

  home.file.".codex/herdr-agent-state.sh".source = script "codex";

  programs.codex = {
    settings.features.hooks = true;
    hooks.SessionStart = [ { hooks = [ (hook ".codex/herdr-agent-state.sh") ]; } ];
  };
}
