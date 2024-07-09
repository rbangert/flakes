inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.neovim;
in {
  options.rr-sv.tools.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      home.packages = with pkgs; [
        less
        neovim
      ];

      #   sessionVariables = {
      #     PAGER = "less";
      #     MANPAGER = "less";
      #     NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      #     EDITOR = "nvim";
      #   };
      #
      #   shellAliases = {
      #     vimdiff = "nvim -d";
      #   };
    };

    # xdg.configFile = {
    #   "dashboard-nvim/.keep".text = "";
    # };
  };
}
