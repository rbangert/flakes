inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.mailpit;
in {
  options.rr-sv.containers.mailpit = with types; {
    enable = mkBoolOpt false "Whether or not to enable mailpit";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "mailpit" = {
          image = "axllent/mailpit:v1.13.1";
          ports = [
            "8025:8025"
            "1025:1025"
          ];
          # environment = {
          # };
        };
      };
    };

    services.nginx.virtualHosts = {
      "mailpit.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8025";
        };
      };
    };

    security.acme.certs."mailpit.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };

    networking.firewall.allowedTCPPorts = [1025];
  };
}
