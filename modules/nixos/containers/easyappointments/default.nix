inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.easyappoitments;
in {
  options.rr-sv.containers.easyappoitments = with types; {
    enable = mkBoolOpt false "Whether or not to enable easyappoitments";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "easyappoitments" = {
          image = "alextselegidis/easyappointments:1.4.3";
          ports = ["8020:80"];
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
        };
        "easyappoitments-db" = {
          image = "mysql:8.0";
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
          volumes = [
            "easyappoitments-data:/app/data"
          ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "easyappoitments.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:80";
        };
      };
    };

    security.acme.certs."easyappoitments.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
