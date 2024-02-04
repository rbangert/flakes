inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.easyappointsments;
in {
  options.rr-sv.containers.easyappointsments = with types; {
    enable = mkBoolOpt false "Whether or not to enable easyappointsments";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "easyappointsments" = {
          image = "alextselegidis/easyappointments:1.4.3";
          ports = ["8020:80"];
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
        };
        "easyappointsments-db" = {
          image = "mysql:8.0";
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
          volumes = [
            "easyappointsments-data:/app/data"
          ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "easyappointsments.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:80";
        };
      };
    };

    security.acme.certs."easyappointsments.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
