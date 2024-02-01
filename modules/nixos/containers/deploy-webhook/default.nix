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
    cd /var/www/$1
    git pull
  '';
in {
  options.rr-sv.containers.deploy-webhook = with types; {
    enable = mkBoolOpt false "Whether or not to enable deploy-webhook";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pull-script];

    containers.deploy-webhook = {
      autoStart = true;
      localAddress = "127.0.0.1";
      config = {
        config,
        pkgs,
        ...
      }: {
        systemd.services."webhook" = {
          enable = true;
          description = "Github deploy-webhook";
          serviceConfig = {
            ExecStart = ''
              ${pkgs.bash}/bin/bash -c "${pkgs.webhook} -hooks \
              ${config.sops.deploy-webhook.path} -logfile \
              /var/log/deploy-webhook
            '';
          };
          wantedBy = ["default.target"];
        };
      };
    };

    services.nginx.virtualHosts = {
      "rr-sv.win" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
