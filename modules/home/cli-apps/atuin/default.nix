{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.atuin;
in {
  options.${namespace}.cli-apps.atuin = {
    enable = mkEnableOption "atuin";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        search_mode = "fuzzy";
        inline_height = 40;
      };
    };
  };
}
