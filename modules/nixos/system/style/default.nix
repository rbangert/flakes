{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.system.style;
  # TODO: Customize KB config
in {
  options.rr-sv.system.style = with types; {
    enable = mkBoolOpt false "Whether or not to enable style";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
