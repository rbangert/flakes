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
        domain = "graf.russellb.dev";
        port = 2342;
        addr = "127.0.0.1";
      };

      nginx.virtualHosts.${config.services.grafana.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${config.services.grafana.port}";
          proxyWebsockets = true;
        };
      };

      security.acme.certs.${config.services.grafana.domain} = {
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        webroot = null;
        credentialsFile = config.sops.secrets.acmecredfile.path;
      };
    };
  };
}
