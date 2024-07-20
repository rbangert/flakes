{ lib, config, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.containers.davis;
in {
  options.${namespace}.containers.davis = {
    enable = mkEnableOption "davis *dav service";
  };

  config = mkIf cfg.enable {
    containers.davis = {
      autoStart = true;
      localAddress = "127.0.0.1";
      config = { config, pkgs, ... }: {
        services.davis = {
          enable = true;
          hostname = "dav.russellb.dev";
          # mail = {
          #   dsn = "smtp://username@example.com:25";
          #   inviteFromAddress = "davis@example.com";
          # };
          adminLogin = "admin";
          adminPasswordFile = "/run/secrets/davis-password";
          appSecretFile = "/run/secrets/davis-secret";
          nginx = { };
        };
      };
    };
    services.nginx.virtualHosts = {
      "dav.russellb.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
