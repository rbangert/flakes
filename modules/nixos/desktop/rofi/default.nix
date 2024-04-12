{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.rofi;
in {
  options.rr-sv.desktop.rofi = with types; {
    enable = mkBoolOpt false "Whether or not to enable rofi.";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      home.packages = with pkgs; [rofi-wayland];

      # xdg.configFile."rofi".source = ../../../../config/rofi;
    };
  };
}
