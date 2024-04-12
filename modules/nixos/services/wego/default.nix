inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.services.wego;
in {
  options.rr-sv.services.wego = with types; {
    enable = mkBoolOpt false "Whether or not to enable wego";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wego
    ];

    #systemd.services."wegorc" = {
    #  script = ''
    #    cat ${config.sops.secrets.wegorc.path} >> .wegorc
    #  '';
    #  serviceConfig = {
    #    WorkingDirectory = "/home/russ";
    #  };
    #};
  };
}
