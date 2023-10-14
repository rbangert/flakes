{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.system.xkb;
  # TODO: Customize KB config
in
{
  options.rr-sv.system.xkb = with types; {
    enable = mkBoolOpt false "Whether or not to enable xkb";
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      xkbOptions = "caps:escape";
    };
  };
}
