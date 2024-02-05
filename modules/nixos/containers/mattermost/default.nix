inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.mattermost;
in {
  options.rr-sv.containers.mattermost = with types; {
    enable = mkBoolOpt false "Whether or not to enable mattermost";
  };

  config = mkIf cfg.enable {
    containers.mattermost = {
      autoStart = true;
      localAddress = "127.0.0.1";
      config = {
        config,
        pkgs,
        ...
      }: {
        services.mattermost = {
          enable = true;
          siteName = "DMA/RussCorp";
          siteUrl = "https://mm.rr-sv.win";
          matterircd.enable = true;
          mutableConfig = true;
          plugins = [
            (pkgs.stdenv.mkDerivation {
              name = "mattermost-plugin-jitsi";
              version = "2.0.1";
              src = pkgs.fetchurl {
                url = "https://github.com/mattermost/mattermost-plugin-jitsi/releases/download/v2.0.1/jitsi-2.0.1.tar.gz";
                sha256 = "sha256-iVmW9ZdNnzq08c929Tf1+xnA7cHWuujbn8BCpf6Zzeo=";
              };

              installPhase = ''
                mkdir -p $out
                cp -r * $out
              '';
            })
          ];
        };
      };
    };

    services.nginx.virtualHosts = {
      "mm.rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8065";
          proxyWebsockets = true;
        };
      };
    };

    security.acme.certs."mm.rr-sv.win" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      credentialsFile = config.sops.secrets.acmeCredFile.path;
    };
  };
}
