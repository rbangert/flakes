{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.fuzzel;
in {
  options.${namespace}.desktop.fuzzel = {
    enable = mkEnableOption "fuzzell";
  };

  config = mkIf cfg.enable {
    home = {
      programs.fuzzel = {
        enable = true;
      };
      # file.".config/rofi" = {
      #   source = ../../../../config/rofi;
      #   recursive = true;
      # };
    };
  };
}
