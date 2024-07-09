inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.eww;
in {
  options.rr-sv.desktop.eww = with types; {
    enable = mkBoolOpt false "Whether or not to enable eww.";
  };

  config = mkIf cfg.enable {
    rr-sv.home = {
      extraOptions.home.packages = with pkgs; [eww];

      # file.".config/eww" = {
      #   source = ../../../../config/eww;
      #   recursive = true;
      # };
    };
  };
}
