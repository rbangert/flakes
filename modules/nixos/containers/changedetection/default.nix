inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.changedetection;
in {
  options.rr-sv.containers.changedetection = with types; {
    enable = mkBoolOpt false "Whether or not to enable changedetection";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "changedetection" = {
          image = "lscr.io/linuxserver/changedetection.io:latest";
          ports = ["5000:5000"];
          environment = {
            PUID = "1000";
            PGID = "1000";
            TZ = "America/Denver";
            BASE_URL = "change.rr-sv.win";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "change.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
        };
      };
    };

    security.acme.certs."change.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
