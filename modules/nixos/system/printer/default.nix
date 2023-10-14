inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.system.printer;

in {
  options.rr-sv.system.printer = with types; {
    enable = mkBoolOpt false "Whether or not to enable printer";
  };

  config = mkIf cfg.enable {
    services = {
        printing.enable = true;
        avahi.enable = true;
        avahi.nssmdns = true;
        avahi.openFirewall = true;
      };
    };
  }
