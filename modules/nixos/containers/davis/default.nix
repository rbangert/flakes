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
          volumes = [ "davis-webdav:/var/www/davis" ];
          environmentFiles = [

          ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "dav.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
          proxyWebsockets = true;
        };
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
