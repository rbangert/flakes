inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.wordpress;
in {
  options.rr-sv.containers.wordpress = with types; {
    enable = mkBoolOpt false "Whether or not to enable wordpress";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "wordpress" = {
          image = "wordpress:latest";
          ports = ["8099:80"];
          volumes = [
            "wordpress_data:/var/www/html"
          ];
          environment = {
            WORDPRESS_DB_HOST = "wordpress-mariadb:3306";
            WORDPRESS_DB_USER = "wordpress";
            WORDPRESS_DB_PASSWORD = "wordpress";
            WORDPRESS_DB_NAME = "wordpress";
          };
        };
        "wordpress-mariadb" = {
          image = "mariadb:10.6.16-focal";
          ports = ["3307:3306"];
          volumes = [
            "db_data:/var/lib/mysql"
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
