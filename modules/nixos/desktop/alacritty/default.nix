inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let 
  cfg = config.rr-sv.desktop.alacritty;
in
{
  options.rr-sv.desktop.alacritty = with types; {
    enable = mkBoolOpt false "Whether or not to enable alacritty" ;
  };

  config = mkIf cfg.enable {
    rr-sv.home.configFile."alacritty/alacritty.yml".source = ./config/alacritty.yml;

    rr-sv.home.extraOptions = {
      programs.alacritty = {
        enable = true;
      };
    };
  };
}
  