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
  options.rr-sv.containers.mattermost = with types; {
    enable = mkBoolOpt false "Whether or not to enable mattermost";
  };

  config = mkIf cfg.enable {
    containers.mattermost = {
      autoStart = true;
      localAddress = "127.0.0.1";
      config = {
        config,
        pkgs,
        ...
      }: {
        services.mattermost = {
          enable = true;
          siteName = "DMA/RussCorp";
          siteUrl = "https://mm.rr-sv.win";
          matterircd.enable = true;
          mutableConfig = true;
        };
      };
    };

    # virtualisation.oci-containers = {
    #   containers = {
    #     "mattermost" = {
    #       image = "mattermost/mattermost-team-edition:9.4";
    #       ports = [
    #         "8065:8065"
    #         "8443:8443/udp"
    #         "8443:8443/tcp"
    #       ];
    #       volumes = [
    #         "mattermost-data:/mattermost"
    #       ];
    #       environmentFiles = [config.sops.secrets.mattermostEnv.path];
    #     };
    #     "mm-postgres" = {
    #       image = "postgres/postgres:16.1-alpine";
    #       volumes = [
    #         "mattermost-pgsql-data:/var/lib/postgresql/data"
    #       ];
    #       environmentFiles = [config.sops.secrets.mattermostEnv.path];
    #     };
    #   };
    # };

    services.nginx.virtualHosts = {
      "mm.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8065";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs."mm.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
