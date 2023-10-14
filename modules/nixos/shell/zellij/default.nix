inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.shell.zellij;
in {
  options.rr-sv.shell.zellij = with types; {
    enable = mkBoolOpt false "Whether or not to enable zellij";
  };

  config = mkIf cfg.enable {
    # rr-sv.home.configFile."alacritty/alacritty.yml".source = ./config/alacritty.yml;

    rr-sv.home.extraOptions = {
      programs.zellij = {
        enable = true;
        enableZshIntegration = true;
        #dataLocation =
        settings = {
          default_shell = "zsh";
          theme = "catppuccin";
        };
        # extraConfig =
      };
    };
  };
}
