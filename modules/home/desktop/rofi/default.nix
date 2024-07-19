{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.desktop.rofi;
in {
  options.${namespace}.desktop.rofi = { enable = mkEnableOption "rofi"; };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      cycle = true;
      location = "center";
      # pass = { };
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji pkgs.rofi-systemd ];
    };
  };
}
