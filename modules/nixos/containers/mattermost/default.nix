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
            (pkgs.fetchurl {
              url = "https://github.com/mattermost/mattermost-plugin-jitsi/releases/download/v2.0.1/jitsi-2.0.1.tar.gz";
              sha256 = "sha256-iVmW9ZdNnzq08c929Tf1+xnA7cHWuujbn8BCpf6Zzeo=";
            })
            (pkgs.fetchurl {
              url = "https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.1.8/github-2.1.8.tar.gz";
              sha256 = "sha256-n9P6FA5+zd2TaAbVhdRxcS8cH48g1HQ51M8jILjqNmE=";
            })
            (pkgs.fetchurl {
              url = "https://github.com/mksondej/mattermost-file-list/releases/download/v0.9.0/mattermost-file-list-0.9.0.tar.gz";
              sha256 = "sha256-ow9vm8axn6aHEkLpIGvy5ia51CjN4rtIXef29gCm9zk=";
            })
            (pkgs.fetchurl {
              url = "https://get.gravitational.com/teleport-access-mattermost-v15.0.0-linux-amd64-bin.tar.gz";
              sha256 = "";
            })
            (pkgs.fetchurl {
              url = "https://github.com/mattermost/mattermost-plugin-gitlab/releases/download/v1.8.0/com.github.manland.mattermost-plugin-gitlab-1.8.0.tar.gz";
              sha256 = "sha256-AetaUPLVARQwyeflCgQciSg8AiDWgqoflyUzOn7R3FY=";
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
