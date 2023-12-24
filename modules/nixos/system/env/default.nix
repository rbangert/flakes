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
        XDG_DESKTOP_DIR = "$HOME/stuff/other/";
      };
      variables = {
        QUTE_QT_WRAPPER = "PyQt6";
        PATH = "$PATH:$HOME/projects/flakes/bin:$HOME/.local/bin:$HOME/.config/emacs/bin:$HOME/go/bin";
        EDITOR = "nvim";
        DOTS = "$HOME/projects/flakes";
        DOTDIR = "$HOME/projects/flakes";
        STUFF = "$HOME/stuff";
        JUNK = "$HOME/stuff/other";
        NB_DIR = "$HOME/projects/org";
        NIXOS_CONFIG_DIR = "$HOME/projects/dots";
        XDG_RUNTIME_DIR = "/run/user/1000";
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
    };
  };
}
