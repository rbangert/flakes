{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.tools.direnv;
in {
  options.rr-sv.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv = enabled;
      };
    };
  };
}
