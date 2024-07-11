{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.alacritty;
in {
  options.${namespace}.desktop.alacritty = {
    enable = mkEnableOption "alacritty";
  };
  config = mkIf cfg.enable {
    home.file."${config.xdg.configHome}/alacritty" = {
      source = ../../../../config/alacritty;
      recursive = true;
    };

    programs.alacritty = {
      enable = true;
    };
  };
}
