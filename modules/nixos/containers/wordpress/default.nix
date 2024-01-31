inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.wp-dev;
in {
  options.rr-sv.containers.wp-dev = with types; {
    enable = mkBoolOpt false "Whether or not to enable wp-dev";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "wp-dev" = {
          image = "wordpress:latest";
          ports = ["8099:80"];
          volumes = [
            "wp-dev-data:/var/www/html"
          ];
          environment = {
            WORDPRESS_DB_HOST = "wp-dev-db:3306";
            WORDPRESS_DB_USER = "wordpress";
            WORDPRESS_DB_PASSWORD = "wordpress";
            WORDPRESS_DB_NAME = "wordpress";
          };
        };
        "wp-dev-db" = {
          image = "mariadb:10.6.16-focal";
          ports = ["3307:3306"];
          volumes = [
            "wp-dev-db_data:/var/lib/mysql"
          ];
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
      "wp-dev.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8099";
        };
      };
    };

    security.acme.certs."wp-dev.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
