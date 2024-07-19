{ config, lib, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.containers.shynet;
in {
  options.rr-sv.containers.shynet = with types; {
    enable = mkBoolOpt false "Whether or not to enable shynet";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "shynet" = {
          image = "shynet:latest";
          environment = { };
        };
        "shynet-db" = {
          image = "postgres:12.19-bookworm";
          volumes = [ "shynet-db-data:/var/lib/postgresql/data" ];
          environment = {

          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "shynet.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = { proxyPass = "http://127.0.0.1:8099"; };
      };
    };

    security.acme.certs."shynet.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
