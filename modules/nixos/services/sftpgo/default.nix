{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.services.sftpgo;
in {
  options.${namespace}.services.sftpgo = {
    enable = mkEnableOption "sftpgo weather service";
  };

  config = mkIf cfg.enable {

    services.sftpgo = { enable = true; };
  };
}
