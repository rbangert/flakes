{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.nextcloud;
in {
  options.${namespace}.services.nextcloud = {
    enable = mkEnableOption "nextcloud service";
  };

  config = mkIf cfg.enable {
    services = {
      nextcloud = {
        enable = true;
        hostName = "cloud.russellb.dev";
        # Need to manually increment with every major upgrade.
        package = pkgs.nextcloud29;
        database.createLocally = true;
        configureRedis = true;
        maxUploadSize = "16G";
        https = true;

        autoUpdateApps.enable = true;
        extraAppsEnable = true;
        # extraApps = with config.services.nextcloud.package.packages.apps; {
        #   # List of apps we want to install and are already packaged in
        #   # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        #   inherit calendar contacts mail notes onlyoffice tasks;

        #   # Custom app installation example.
        #   cookbook = pkgs.fetchNextcloudApp rec {
        #     url =
        #       "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
        #     sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        #   };
        # };

        settings = {
          #   overwriteprotocol = "https";
          #   default_phone_region = "US";
          # trusted_domains = [  ];
          trusted_proxies = [ "100.119.211.85" "107.172.20.201" ];
        };
        config = {
          # dbtype = "pgsql";
          adminuser = "admin";
          adminpassFile = "/run/secrets/nextcloud_pass";
        };
      };

      onlyoffice = {
        enable = false;
        hostname = "docs.russellb.dev";
      };
    };

    services.nginx.virtualHosts = {
      "cloud.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
      };
    };

    security.acme.certs."cloud.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
