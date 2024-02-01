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

    systemd.services."webhook" = {
      enable = true;
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Description = "Github deploy-webhook";
        Restart = "always";
        RestartSec = "15s";
        User = "russ";
        ExecStart = ''
          ${pkgs.bash}/bin/bash -c "${pkgs.webhook} -hooks \
          /run/secrets/deploy-webhook -logfile \
          /var/log/deploy-webhook
        '';
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
