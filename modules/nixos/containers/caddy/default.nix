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
      hostAddress = "0.0.0.0";
      config = {
        config,
        pkgs,
        ...
      }: {
        services.caddy = {
          enable = true;
          virtualHosts."mm.dmaservices.cc".extraConfig = ''
            reverse_proxy http://10.0.100.100
          '';
        };
      };
    };
  };
}
