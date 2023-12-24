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
  options.rr-sv. containers.caddy = with types; {
    enable = mkBoolOpt false "Whether or not to enable caddy";
  };

  config = mkIf cfg.enable {
    virtualization.oci-containers = {
      caddy = {
        image = "slothcroissant/caddy:2.7.6";
        autoStart = true;
        ports = [
          "172.245.210.126:80:80"
          "172.245.210.126:443:443"
          "172.245.210.126:443:443/udp"
        ];
        volumes = [
          "/home/russ/www:/var/www"
          "/home/russ/caddy:/data"
          "/home/russ/caddy/Caddyfile:/etc/caddy/Caddyfile"
        ];
        environment = {
          "TZ" = "America/Denver";
          "ACME_AGREE" = "true";
        };
        extraOptions = [
          "--name=caddy"
          "--network=caddy"
        ];
      };
    };
  };
}
