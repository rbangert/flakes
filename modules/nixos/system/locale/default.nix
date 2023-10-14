{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let cfg = config.rr-sv.system.locale;

in {
  options.rr-sv.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to enable locale"; };
  config = mkIf cfg.enable {
    
    i18n.defaultLocale = "en_US.UTF-8";
      console = {
          font = "Lat2-Terminus16";
          keyMap = mkForce "us";
      };
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };  
  };
}
