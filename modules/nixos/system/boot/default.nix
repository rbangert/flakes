{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;

let cfg = config.rr-sv.system.boot;
in {
  options.rr-sv.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable boot";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
    };
  };
}
