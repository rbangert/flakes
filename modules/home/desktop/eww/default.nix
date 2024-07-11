{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.eww;
in {
  options.${namespace}.desktop.eww = {
    enable = mkEnableOption "eww";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [eww];

      file.".config/eww" = {
        source = ../../../../config/eww;
        recursive = true;
      };
    };
  };
}
