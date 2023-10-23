inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualisation.lxc;
in {
  options.rr-sv.virtualisation.lxc = with types; {
    enable = mkBoolOpt false "Whether or not to enable lxc/d containers";
  };

  config = mkIf cfg.enable {
    virtualisation.lxd = {
      enable = true;
    };

    virtualisation.lxc = {
      enable = true;
      usernetConfig = ''
        russ veth lxcbr0 50
      '';
      systemConfig = ''
        lxc.net.0.type = veth
        lxc.net.0.link = virbr0
        lxc.net.0.flags = up
        lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
        lxc.idmap = u 0 100000 65536
        lxc.idmap = g 0 100000 65536
      '';
    };
  };
}
