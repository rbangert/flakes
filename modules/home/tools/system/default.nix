{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.tools.system;
in {
  options.${namespace}.tools.system = {
    enable = mkEnableOption "system tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        dig
        whois
        inetutils
        nmap
        usbutils
        unzip
        nfs-utils
        ventoy
        at
        killall
        git
        gparted
      ];
    };
  };
}
