inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.containers.vaultwarden;
in {
  options.rr-sv.containers.vaultwarden = with types; {
    enable = mkBoolOpt false "Whether or not to enable vaultwarden";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "vaultwarden" = {
          image = "vaultwarden/server:1.31.0-alpine";
          ports = [ "8119:80" ];
          volumes = [ "vaultwarden-data:/data" ];
          environment = {
            SIGNUPS_ALLOWED = "false";
            IP_HEADER = "none";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "vault.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8119";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs."vault.russellb.dev" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
