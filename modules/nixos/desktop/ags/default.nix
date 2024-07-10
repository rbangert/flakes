inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.ags;
in {
  options.rr-sv.desktop.ags = with types; {
    enable = mkBoolOpt false "Whether or not to enable ags.";
  };

  config = mkIf cfg.enable {
    rr-sv.home = {
      extraOptions = {
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
      };

      # programs.ags.enable = true;
      # file.".config/ags" = {
      #   source = ../../../../config/ags;
      #   recursive = true;
      # };
    };
  };
}
