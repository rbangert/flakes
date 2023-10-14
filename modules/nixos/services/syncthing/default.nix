inputs@{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.syncthing;

in {
  options.rr-sv.services.syncthing = with types; {
    enable = mkBoolOpt false "Whether or not to enable syncthing";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
    syncthing
    syncthingtray
    ];

  services.syncthing = {
    enable = true;
    user = "russ";
    systemService = true;
    dataDir = "/home/russ/stuff/sync";
    };
  };
}
