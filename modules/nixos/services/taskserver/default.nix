inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.services.taskserver;
in {
  options.rr-sv.services.taskserver = with types; {
    enable = mkBoolOpt false "Whether or not to enable taskserver";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [53589];
    };

    services.taskserver = {
      enable = true;
      fqdn = "task.rr-sv.win";
      listenHost = "::";
      # dataDir = "/p/tasks";
      organisations.personal.users = ["russ"];
      # manual.server.key = ;
      # manual.server.cert = ;
    };
  };
}
