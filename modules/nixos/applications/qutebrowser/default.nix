{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.applications.qutebrowser;
in {
  options.${namespace}.applications.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };
  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      # Disable to prevent loading default key bindings.
      enableDefaultBindings = true;
    };

    home.sessionVariables = {DEFAULT_BROWSER = "${pkgs.qutebrowser}/bin/qutebrowser";};

    home.packages = with pkgs; [
      qutebrowser
    ];

    home.file.".config/qutebrowser" = {
      source = ../../../../config/qutebrowser;
      recursive = true;
    };
  };
}
