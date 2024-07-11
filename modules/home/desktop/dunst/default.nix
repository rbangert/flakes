{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.dunst;
in {
  options.${namespace}.desktop.dunst = {
    enable = mkEnableOption "dunst";
  };
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 1;
          origin = "bottom-right";
          offset = "60x12";
          separator_height = 2;
          padding = 12;
          horizontal_padding = 12;
          text_icon_padding = 12;
          frame_width = 4;
          separator_color = "frame";
          idle_threshold = 120;
          font = "JetBrainsMono Nerdfont 12";
          line_height = 0;
          format = "<b>%s</b>%b";
          alignment = "center";
          icon_position = "center";
          corner_radius = 12;

          frame_color = "#bd93f9";
          background = "#303241";
          foreground = "#F38BA8";
          timeout = 10;
        };
      };
    };
  };
}
