inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.easyappointments;
in {
  options.rr-sv.containers.easyappointments = with types; {
    enable = mkBoolOpt false "Whether or not to enable easyappointments";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "easyappointments" = {
          image = "alextselegidis/easyappointments:1.4.3";
          ports = ["8020:80"];
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
        };
        "easyappointments-db" = {
          image = "mysql:8.0";
          ports = ["3306"];
          environmentFiles = [
            /run/secrets/easyappointmentsEnv
          ];
          volumes = [
            "easyappointments-data:/app/data"
          ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "appt.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8020";
        };
      };
    };

    security.acme.certs."appt.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
