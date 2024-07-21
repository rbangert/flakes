{ lib, config, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.containers.davis;
in {
  options.${namespace}.containers.davis = {
    enable = mkEnableOption "davis *dav service";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "davis-webdav" = {
          image = "ghcr.io/tchapi/davis:edge";
          ports = [ "8090:80" ];
          volumes = [ "/srv/webdav:/var/www/davis" ];
          environmentFiles = [ config.sops.secrets.davis_dotenv.path ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "dav.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/srv/webdav";
          tryFiles = "$uri /index.php$is_args$args;";
        };
        locations."/bundles".tryFiles = "$uri =404;";
        locations."/bundles".tryFiles = "$uri =404;";
      };
    };

    security.acme.certs."dav.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
