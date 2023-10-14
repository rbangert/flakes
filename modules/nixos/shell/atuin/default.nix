inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.shell.atuin;
in {
  options.rr-sv.shell.atuin = with types; {
    enable = mkBoolOpt false "Whether or not to enable atuin";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          search_mode = "fuzzy";
          inline_height = 40;
        };
      };
    };
  };
}
