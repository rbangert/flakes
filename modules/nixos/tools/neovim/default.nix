inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let cfg = config.rr-sv.tools.neovim;

in {
  options.rr-sv.tools.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.nixvim = {
        enable = true;

        colorschemes.gruvbox.enable = true;
        plugins.lightline.enable = true;
      };
    };
  };
}
