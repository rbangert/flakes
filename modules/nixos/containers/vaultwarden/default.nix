inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.vaultwarden;
in {
  options.rr-sv.containers.vaultwarden = with types; {
    enable = mkBoolOpt false "Whether or not to enable vaultwarden";
  };

  config = mkIf cfg.enable {
    containers.vaultwarden = {
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
          siteUrl = "http://mm.dmaservices.ca";

          # envionmentFile = "${config.services.mattermost.dataDir}/config.json";
        };
      };
    };
  };
}
