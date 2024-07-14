{ config, lib, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.containers.home-assistant;
in {
  options.rr-sv.containers.home-assistant = with types; {
    enable = mkBoolOpt false "Whether or not to enable home-assistant";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers = {
        "home-assistant" = {
          image = "ghcr.io/home-assistant/home-assistant:stable";
          ports = [ "8123:8123" ];
          user = "1000:1000";
          priviledged = true;
          networkMode = "host";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/opt/homeassistant/config:/config"
          ];
        };
      };
    };
  };
}
