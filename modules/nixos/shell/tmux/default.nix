{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.shell.tmux;
  configFiles = lib.snowfall.fs.get-files ../../../../config/tmux;

  plugins = with pkgs.tmuxPlugins; [
    # TODO tmux add maildir-counter
    tokyo-night-tmux
    tilish
    vim-tmux-navigator
    tmux-fzf
    cpu
    {
      plugin = weather;
      extraConfig = ''
        set -g @forecast-format '%c %t %w'+'|'+'Dawn/Dusk:'+'%D/%d'+'%m'
        set -g @forecast-location '41.79,-107.23'
      '';
    }
  ];
in {
  options.rr-sv.shell.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to enable tmux.";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.tmux = {
        enable = true;
        historyLimit = 2000;
        keyMode = "vi";
        terminal = "tmux-256color";
        mouse = true;
        shell = "/etc/profiles/per-user/russ/bin/zsh";
        newSession = true;
        tmuxinator.enable = true;
        extraConfig =
          builtins.concatStringsSep "\n"
          (builtins.map lib.strings.fileContents configFiles);

        inherit plugins;
      };
    };
  };
}
