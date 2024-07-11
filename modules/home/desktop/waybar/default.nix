{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.waybar;
in {
  options.${namespace}.desktop.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [waybar];

      file.".config/waybar" = {
        source = ../../../../config/waybar;
        recursive = true;
      };
    };
  };
}
