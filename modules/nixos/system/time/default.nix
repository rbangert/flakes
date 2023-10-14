{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let cfg = config.rr-sv.system.time;

in {
  options.rr-sv.system.time = with types; {
    enable = mkBoolOpt false "Whether or not to enable time"; };

# TODO: Pull location from IP to determine TZ later
  config = mkIf cfg.enable { time.timeZone = "America/Denver"; };
}
