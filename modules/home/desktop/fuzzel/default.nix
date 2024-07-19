{ pkgs, lib, config, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.desktop.fuzzel;
in {
  options.${namespace}.desktop.fuzzel = { enable = mkEnableOption "fuzzel"; };

  config = mkIf cfg.enable {
    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
      main = {
        font = lib.mkForce ":size=20";
        dpi-aware = "no";
        show-actions = "yes";
        terminal = "${pkgs.alacritty}/bin/alacritty";
      };
      # colors = {
      #   background = config.lib.stylix.colors.base00 + "bf";
      #   text = config.lib.stylix.colors.base07 + "ff";
      #   match = config.lib.stylix.colors.base05 + "ff";
      #   selection = config.lib.stylix.colors.base08 + "ff";
      #   selection-text = config.lib.stylix.colors.base00 + "ff";
      #   selection-match = config.lib.stylix.colors.base05 + "ff";
      #   border = config.lib.stylix.colors.base08 + "ff";
      # };
      border = {
        width = 3;
        radius = 7;
      };
    };
  };
}
