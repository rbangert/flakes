inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.grafana;

in
{
  options.rr-sv.services.grafana = with types; {
    enable = mkBoolOpt false "Whether or not to enable grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
          enable = true;
	  settings = {
		services = {
          domain = "graf.rr-sv.win";
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
	};
	};

    # nginx reverse proxy
    services.nginx.enable = true;  
    services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };
}
