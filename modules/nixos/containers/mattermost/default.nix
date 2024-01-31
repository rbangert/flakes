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
    virtualisation.oci-containers = {
      containers = {
        "mattermost" = {
          image = "mattermost/mattermost-team-edition:9.4";
          ports = ["3000:3000"];
          volumes = [
            "mattermost-data:/mattermost"
          ];
          environmentFiles = config.sops.secrets.mattermostEnv.path;
        };
        "mm-postgres" = {
          image = "postgres/postgres:16.1-alpine";
          # ports = ["3000:3000"];
          volumes = [
            "mattermost-pgsql-data:/var/lib/postgresql/data"
          ];
          environmentFiles = config.sops.secrets.mattermostEnv.path;
        };
      };
    };

    services.nginx.virtualHosts = {
      "mm.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8030";
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
