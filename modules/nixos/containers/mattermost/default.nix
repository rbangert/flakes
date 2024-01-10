inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.mattermost;
in {
  options.rr-sv. containers.mattermost = with types; {
    enable = mkBoolOpt false "Whether or not to enable mattermost";
  };

  config = mkIf cfg.enable {
    containers.mattermost = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "10.0.100.100";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      config = {
        config,
        pkgs,
        ...
      }: {
        services.mattermost = {
          enable = true;
          siteUrl = "http://mm.dmaservices.cc";

          # envionmentFile = "${config.services.mattermost.dataDir}/config.json";
        };
      };
    };
  };
}
