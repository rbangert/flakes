inputs @ { options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualisation.lxc;
in
{
  options.rr-sv.virtualisation.lxc = with types; {
    enable = mkBoolOpt false "Whether or not to enable lxc/d containers";
  };

  config = mkIf cfg.enable {
    virtualisation.lxd = {
      enable = true;
    };

    virtualisation.lxc = {
      enable = true;
    };

    rr-sv.home.extraGroups = [ "lxd" "lxc" ];
  };
}
      

