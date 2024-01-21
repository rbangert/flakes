{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.services.nfs;
  # configFiles = lib.snowfall.fs.get-files ../../../../config/ssh;
in {
  options.rr-sv.services.nfs = with types; {
    enable = mkBoolOpt false "Whether or not to enable nfs.";
  };

  config = mkIf cfg.enable {
    services.nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4003;
      exports = ''
        /exports/home 10.0.0.33(rw,fsid=0,no_subtree_check) 100.65.34.18(rw,fsid=0,no_subtree_check)
      '';
    };
    networking.firewall = {
      # for NFSv3; view with `rpcinfo -p`
      allowedTCPPorts = [111 2049 4000 4001 4002 20048];
      allowedUDPPorts = [111 2049 4000 4001 4002 20048];
    };
  };
}
