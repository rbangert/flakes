inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.virtualisation.incus;
in {
  options.rr-sv.virtualisation.incus = with types; {
    enable = mkBoolOpt false "Whether or not to enable incus";
  };

  config = mkIf cfg.enable {
    virtualisation.incus = {
      enable = true;
    };
  };
}
