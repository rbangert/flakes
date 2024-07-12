inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.gitea;
in {
  options.rr-sv.containers.gitea = with types; {
    enable = mkBoolOpt false "Whether or not to enable gitea";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "gitea" = {
          image = "gitea/gitea:1.21.4-rootless";
          ports = [
            "3000:3000"
            "222:22"
          ];
          volumes = [
            "gitea-data:/data"
          ];
          environment = {
            DISABLE_REGISTRATION = "true";
          };
        };
      };
    };

    services.nginx.virtualHosts = {
      "git.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };

    security.acme.certs."git.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmecredfile.path;
    };
  };
}
