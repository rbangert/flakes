inputs@{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.containers.webdev;
  domain = "wp-dev.rr-sv.win";
in {
  options.rr-sv.containers.webdev = with types; {
    enable = mkBoolOpt false "Whether or not to enable webdev";
  };

  config = mkIf cfg.enable {
    services = {
      nginx.virtualHosts.${domain} = {
        enableACME = true;
        forceSSL = true;
      };

      wordpress = {
        webserver = "nginx";
        sites."${domain}" = {
          plugins = { inherit google-site-kit; };
          themes = { inherit astra; };
          settings = { WP_DEFAULT_THEME = "astra"; };
        };
      };
    };
  };
}
