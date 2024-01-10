inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.containers.caddy;
in {
  options.rr-sv.containers.caddy = with types; {
    enable = mkBoolOpt false "Whether or not to enable caddy";
  };

  config = mkIf cfg.enable {
    containers.caddy = {
      autoStart = true;
      hostAdress = "0.0.0.0";
      port = [80 443];
      config = {
        config,
        pkgs,
        ...
      }: {
        services.caddy = {
          enable = true;
          virtualHosts."localhost".extraConfig = ''
            respond "Hello, world!"
          '';
        };
      };
    };
  };
}
