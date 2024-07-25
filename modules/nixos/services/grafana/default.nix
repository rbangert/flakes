{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.grafana;
in {
  options.${namespace}.services.grafana = {
    enable = mkEnableOption "grafana service";
  };

  config = mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings = {
          security = {
            admin_user = "admin";
            admin_password = config.sops.secrets.grafanaadminpass;
          };
          server = {
            http_port = 2342;
            domain = "graf.russellb.dev";
          };
        };
      };

      nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${
              toString config.services.grafana.settings.server.http_port
            }";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs.${config.services.grafana.settings.server.domain} = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
