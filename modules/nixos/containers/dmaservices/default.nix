inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.dmaservices;
  pull-script = pkgs.writeScript "pull-script" ''
    cd /var/www/$1
    git pull
  '';
in {
  options.rr-sv.containers.dmaservices = with types; {
    enable = mkBoolOpt false "Whether or not to enable dmaservices";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "dmaservices.cc" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/dmaservices.cc/public";
      };
    };

    security.acme.certs."dmaservices.cc" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
