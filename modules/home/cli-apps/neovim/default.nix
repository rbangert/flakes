{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.neovim;
in {
  options.${namespace}.cli-apps.neovim = {
    enable = mkEnableOption "neovim";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rr-sv.neovim
      ];
    };

    xdg.configFile = {
      "dashboard-nvim/.keep".text = "";
    };
  };
}
