{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.keybase;
in {
  options.rr-sv.tools.keybase = with types; {
    enable = mkBoolOpt false "Whether or not to enable keybase.";
  };

  config = mkIf cfg.enable {
    services.keybase.enable = true;
    services.kbfs = {
      enable = true;
      enableRedirector = true;
      #mountPoint = "/run/user/1000/keybase/kbfs";
    };

    security.wrappers.keybase-redirector = {
      owner = "root";
      group = "wheel";
      setuid = true;
      source = "${pkgs.kbfs}/bin/redirector";
    };
  };
}
