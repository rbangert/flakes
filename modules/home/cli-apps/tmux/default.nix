{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) enabled;
  plugins = with pkgs.tmuxPlugins; [
    # TODO tmux add maildir-counter
    catppuccin
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
  configFiles = lib.snowfall.fs.get-files ../../../../config/tmux;
  cfg = config.${namespace}.cli-apps.tmux;
in {
  options.${namespace}.cli-apps.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      historyLimit = 2000;
      keyMode = "vi";
      terminal = "tmux-256color";
      mouse = true;
      shell = "/etc/profiles/per-user/russ/bin/zsh";
      tmuxinator.enable = true;
      extraConfig =
        builtins.concatStringsSep "\n"
        (builtins.map lib.strings.fileContents configFiles);

      inherit plugins;
    };
  };
}
