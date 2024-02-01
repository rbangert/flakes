inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.deploy-webhook;
  pull-script = pkgs.writeScriptBin "pull-script" ''
    #!/usr/bin/env bash

    cd /var/www/$1
    git pull
  '';
in {
  options.rr-sv.containers.deploy-webhook = with types; {
    enable = mkBoolOpt false "Whether or not to enable deploy-webhook";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pull-script pkgs.webhook];

    systemd = {
      tmpfiles.rules = [
        "d /var/log/deploy-webhook 0640 russ users"
      ];
      services."webhook" = {
        enable = true;
        wantedBy = ["multi-user.target"];
        unitConfig = {
          Description = "Github deploy-webhook";
          Wants = "network-online.target";
          After = "network-online.target";
        };
        serviceConfig = {
          Restart = "always";
          RestartSec = "15s";
          User = "russ";
          ExecStart = ''
            ${pkgs.bash}/bin/bash -c '${pkgs.webhook}/bin/webhook -hooks \
            /run/secrets/deploy-webhook'
          '';
        };
      };
    };

    services.nginx.virtualHosts = {
      "rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/hooks/deploy-webhook" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
