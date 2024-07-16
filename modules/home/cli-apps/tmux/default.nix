{ lib
, config
, pkgs
, namespace
, ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.tmux;
  configFiles = lib.snowfall.fs.get-files ../../../../config/tmux;

  plugins = with pkgs.tmuxPlugins; [
    # TODO tmux add maildir-counter
    tokyo-night-tmux
    vim-tmux-navigator
    tmux-fzf
    tilish
    cpu
    # {
    #   plugin = weather;
    #   extraConfig = ''
    #     set -g @forecast-format '%c %t %w'+'|'+'Dawn/Dusk:'+'%D/%d'+'%m'
    #     set -g @forecast-location '41.79,-107.23'
    #   '';
    # }
  ];
in
{
  options.${namespace}.cli-apps.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      historyLimit = 2000;
      keyMode = "vi";
      terminal = "tmux-256color";
      baseIndex = 1;
      mouse = true;
      shell = "/etc/profiles/per-user/russ/bin/zsh";
      newSession = true;
      tmuxinator.enable = true;
      extraConfig =
        builtins.concatStringsSep "\n"
          (builtins.map lib.strings.fileContents configFiles);

      inherit plugins;
    };
    home.packages = with pkgs; [
      asciiquarium
    ];
  };
}
