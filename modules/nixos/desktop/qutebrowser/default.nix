
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.qutebrowser;
in {
  options.rr-sv.desktop.qutebrowser = with types; {
    enable = mkBoolOpt false "Whether or not to enable qutebrowser.";
  };

  config = mkIf cfg.enable {

      file.".config/qutebrowser" = {
        source = ../../../../config/qutebrowser;
        recursive = true;
      };

      programs.qutebrowser.enable = true;
    };
  }
