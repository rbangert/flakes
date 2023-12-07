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
      };

      nix = {
        os = enabled;
        flake = enabled;
      };

      system = {
        boot = enabled;
        env = enabled;
        locale = enabled;
        time = enabled;
      };
    };

    environment = {
      defaultPackages = [];
      systemPackages = with pkgs; [
      ];
    };
  };
}
