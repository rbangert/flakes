inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.mealie;
in {
  options.rr-sv.containers.mealie = with types; {
    enable = mkBoolOpt false "Whether or not to enable mealie";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "mealie" = {
          image = "ghcr.io/mealie-recipes/mealie:v1.1.0";
          ports = ["9925:9000"];
          volumes = [
            "mealie-data:/app/data"
          ];
          environment = {
            ALLOW_SIGNUP = "true";
            PUID = "1000";
            PGID = "1000";
            TZ = "America/Denver";
            BASE_URL = "mealie.rr-sv.win";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "mealie.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9925";
        };
      };
    };

    security.acme.certs."mealie.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
