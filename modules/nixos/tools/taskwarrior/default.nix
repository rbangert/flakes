inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.taskwarrior;
in {
  options.rr-sv.tools.taskwarrior = with types; {
    enable = mkBoolOpt false "Whether or not to enable taskwarrior";
  };

  config = mkIf cfg.enable {
    # rr-sv.home.configFile."alacritty/alacritty.yml".source = ./config/alacritty.yml;

    environment.systemPackages = with pkgs; [
      taskwarrior-tui
      tasksh
      vit
      python311Packages.tasklib
      ptask
      gnomeExtensions.taskwhisperer
      taskopen
    ];

    rr-sv.home.extraOptions = {
      programs.taskwarrior = {
        enable = true;
        colorTheme = "dark-256";
        # config = {
        #
        # };
      };
    };
  };
}
