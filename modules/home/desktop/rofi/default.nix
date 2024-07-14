{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.desktop.rofi;
in {
  options.${namespace}.desktop.rofi = { enable = mkEnableOption "rofi"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ rofi-wayland ];

      file.".config/rofi" = {
        source = ../../../../config/rofi;
        recursive = true;
      };
    };
  };
}
