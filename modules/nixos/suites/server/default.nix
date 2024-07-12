{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.suites.server;
in {
  options.rr-sv.suites.server = {
    enable = mkBoolOpt false "Whether or not to enable server suite";
  };

  config = mkIf cfg.enable {
    rr-sv = {
      services = {
        openssh = enabled;
        tailscale = enabled;
      };

      nix = {
        os = enabled;
      };

      system = {
        locale = enabled;
        time = enabled;
      };
    };
  };
}
