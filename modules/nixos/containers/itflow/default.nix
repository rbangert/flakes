{ config, lib, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.containers.itflow;
in {
  options.rr-sv.containers.itflow = with types; {
    enable = mkBoolOpt false "Whether or not to enable itflow";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "itflow" = {
          image = "lued/itflow";
          ports = [ "8059:80" ];
          volumes = [ "itflow-data:/var/www/html" ];
          environmentFiles = [ /run/secrets/itflow_env ];
        };
        "itflow-db" = {
          image = "mariadb:10.6.16-focal";
          # ports = ["3307:3306"];
          volumes = [ "itflow-db_data:/var/lib/mysql" ];
          environment = {
            MYSQL_ROOT_PASSWORD = "rootpress";
            MYSQL_DATABASE = "wordpress";
            MYSQL_USER = "wordpress";
            MYSQL_PASSWORD = "wordpress";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "it.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = { proxyPass = "http://127.0.0.1:8059"; };
      };
    };

    security.acme.certs."it.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}