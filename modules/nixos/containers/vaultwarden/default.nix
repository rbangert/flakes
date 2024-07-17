inputs @ { options
, config
, lib
, pkgs
, ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.vaultwarden;
in
{
  options.rr-sv.containers.vaultwarden = with types; {
    enable = mkBoolOpt false "Whether or not to enable vaultwarden";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "vaultwarden" = {
          image = "vaultwarden:1.31.0";
          ports = [ "8119:80" ];
          volumes = [
            "/opt/vaultwarden:/data"
          ];
          environment = {
            SIGNUPS_ALLOWED = "true";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "vault.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8119";
        };
      };
    };

    security.acme.certs."vault.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
