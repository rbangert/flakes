{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.applications.keybase;
in {
  options.rr-sv.applications.keybase = with types; {
    enable = mkBoolOpt false "Whether or not to enable keybase.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [keybase-gui];
  };
}
