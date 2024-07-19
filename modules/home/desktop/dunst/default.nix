{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.desktop.dunst;
in {
  options.${namespace}.desktop.dunst = { enable = mkEnableOption "dunst"; };
  config = mkIf cfg.enable {
    services.fnott.enable = true;
    services.fnott.settings = {
      main = {
        anchor = "bottom-right";
        stacking-order = "top-down";
        min-width = 400;
        title-font = ":size=14";
        summary-font = ":size=12";
        body-font = ":size=11";
        border-size = 0;
      };
      low = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base03 + "ff";
        summary-color = config.lib.stylix.colors.base03 + "ff";
        body-color = config.lib.stylix.colors.base03 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      normal = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base07 + "ff";
        summary-color = config.lib.stylix.colors.base07 + "ff";
        body-color = config.lib.stylix.colors.base07 + "ff";
        idle-timeout = 150;
        max-timeout = 30;
        default-timeout = 8;
      };
      critical = {
        background = config.lib.stylix.colors.base00 + "e6";
        title-color = config.lib.stylix.colors.base08 + "ff";
        summary-color = config.lib.stylix.colors.base08 + "ff";
        body-color = config.lib.stylix.colors.base08 + "ff";
        idle-timeout = 0;
        max-timeout = 0;
        default-timeout = 0;
      };
    };
    # services.dunst = {
    #   enable = true;
    #   settings = {
    #     global = {
    #       monitor = 1;
    #       origin = "bottom-right";
    #       offset = "60x12";
    #       separator_height = 2;
    #       padding = 12;
    #       horizontal_padding = 12;
    #       text_icon_padding = 12;
    #       frame_width = 4;
    #       idle_threshold = 120;
    #       line_height = 0;
    #       format = "<b>%s</b>%b";
    #       alignment = "center";
    #       icon_position = "center";
    #       corner_radius = 12;

    #       frame_color = "#bd93f9";
    #       background = "#303241";
    #       foreground = "#F38BA8";
    #       timeout = 10;
    #     };
    #   };
  };
}
