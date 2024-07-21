{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.sftpgo;
in {
  options.${namespace}.services.sftpgo = {
    enable = mkEnableOption "sftpgo weather service";
  };

  config = mkIf cfg.enable {

    services.sftpgo = {
      enable = true;
      settings = {
        proxy_protocol = 1;
        proxy_allowed = [ "107.172.20.201" ];
        httpd.bindings = [{ port = 8888; }];
        webdavd.bindings = [{
          port = 888;
          proxy_allowed = [ "107.172.20.201" ];
        }];
      };
    };

    services.nginx.virtualHosts = {
      "davmin.russellb.dev" = {
        forcessl = true;
        enableacme = true;
        locations."/" = {
          proxypass = "http://127.0.0.1:8888";
          proxywebsockets = true;
        };
      };
    };
    services.nginx.virtualHosts = {
      "dav.russellb.dev" = {
        forcessl = true;
        enableacme = true;
        locations."/" = {
          proxypass = "http://127.0.0.1:888";
          proxywebsockets = true;
        };
      };
    };

    security.acme.certs."davmin.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };

    security.acme.certs."dav.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };

  };
}
