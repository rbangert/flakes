inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.gotify;
in {
  options.rr-sv.containers.gotify = with types; {
    enable = mkBoolOpt false "Whether or not to enable gotify";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "gotify" = {
          image = "gotify/server:2.4.0";
          ports = ["3030:80"];
          environment = {
            # DISABLE_REGISTRATION = "true";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "gotify.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3030";
        };
      };
    };

    security.acme.certs."gotify.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
