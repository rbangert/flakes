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
      exports = ''
        /export *(rw,sync,no_subtree_check,no_root_squash)
      '';
    };
    networking.firewall = {
      # for NFSv3; view with `rpcinfo -p`
      allowedTCPPorts = [111 2049 4000 4001 4002 20048];
      allowedUDPPorts = [111 2049 4000 4001 4002 20048];
    };
  };
}
