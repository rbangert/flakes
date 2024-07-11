{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.services.wego;
in {
  options.${namespace}.services.wego = {
    enable = mkEnableOption "wego weather service";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wego
    ];

    systemd.services."wegorc" = {
      script = ''
        cat ${config.sops.secrets.wegorc.path} >> .wegorc
      '';
      serviceConfig = {
        WorkingDirectory = "/home/russ";
      };
    };
  };
}
