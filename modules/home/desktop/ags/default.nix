{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.ags;
in {
  options.${namespace}.desktop.ags = {
    enable = mkEnableOption "ags";
  };
  config = mkIf cfg.enable {
    programs.ags.enable = true;

    home.packages = with pkgs; [
      bun
      dart-sass
      fd
      brightnessctl
      swww
      slurp
      wf-recorder
      wl-clipboard
      wayshot
      swappy
      libdbusmenu-gtk3
      hyprpicker
      pavucontrol
      networkmanager
      gtksourceview
      webkitgtk
      gtk3
    ];

    home.file.".config/ags" = {
      source = ../../../../config/ags;
      recursive = true;
    };
  };
}
