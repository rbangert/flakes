inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.containers.webdev;
  domain = "wp-dev.rr-sv.win";
in {
  options.rr-sv.containers.webdev = with types; {
    enable = mkBoolOpt false "Whether or not to enable webdev";
  };

  config = mkIf cfg.enable {
    users.users.www-wordpress = {
      isNormalUser = true;
      group = "www-wordpress";
      packages = with pkgs; [
        git # maybe you want or need this
        php82 # specify whatever version you want
        php82.packages.composer
      ];
    };

    users.groups.www-wordpress = { };

    services.phpfpm.pools.wordpress = {
      phpPackage = pkgs.php82;
      user = "www-wordpress";
      group = "www-wordpress";
      settings = {
        "listen.owner" = config.services.nginx.user; # or nginx, httpd, etc...
        "listen.group" = config.services.nginx.group;
        "pm" =
          "dynamic"; # tweak the below options as needed, though the can be a decent start depending on your work load
        "pm.max_children" = 16;
        "pm.start_servers" = 4;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 2000;
      };
    };

    services.mysql.enable = true;
    services.mysql.package = pkgs.mariadb;
    services.mysql.ensureDatabases = [ "wordpress" ];
    services.mysql.ensureUsers = [{
      name = "www-wordpress";
      ensurePermissions = { "*.*" = "SELECT, INSERT, UPDATE, DELETE"; };
    }];

    services = {
      nginx.virtualHosts.${domain} = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/wp-dev";
      };
    };
  };
}
