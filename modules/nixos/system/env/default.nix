{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.system.env;
in {
  options.rr-sv.system.env = with types; {
    enable = mkBoolOpt false "Whether or not to enable env";
  };
  config = mkIf cfg.enable {
    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_RUNTIME_DIR = "/run/user/1000";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME/s/other/";
      };
      variables = {
        QUTE_QT_WRAPPER = "PyQt6";
        PATH = "$PATH:$HOME/.local/bin:$HOME/.emacs.d/bin:$HOME/go/bin";
        EDITOR = "emacs";
        DOTS = "$HOME/p/dots";
        DOTDIR = "$HOME/p/dots";
        STUFF = "$HOME/s";
        JUNK = "$HOME/s/other";
        NB_DIR = "$HOME/p/org";
        NIXOS_CONFIG_DIR = "$HOME/p/dots";
        XDG_RUNTIME_DIR = "/run/user/1000";
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
    };
  };
}
