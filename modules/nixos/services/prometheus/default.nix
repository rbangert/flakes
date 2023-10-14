inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.prometheus;

in
{
  options.rr-sv.services.prometheus = with types; {
    enable = mkBoolOpt false "Whether or not to enable prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9001;
      scrapeConfigs = [
        {
          job_name = "devbox exporter";
          static_configs = [{
            targets = [ "127.0.0.1:9002" ];
          }];
        }
      ];
    };
  };
}
