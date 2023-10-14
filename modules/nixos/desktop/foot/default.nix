inputs @ {
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.desktop.foot;
in {
  options.rr-sv.desktop.foot = with types; {
    enable = mkBoolOpt false "Whether or not to enable foot";
  };

  config = mkIf cfg.enable {
    rr-sv.home.extraOptions = {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "JetBrainsMono Nerdfont:size=10:line-height=16px";
            pad = "12x12";
          };
          cursor = {
            style = "beam";
            beam-thickness = 2;
          };
          url = {
            launch = "xdg-open \${url}";
            label-letters = "sadfjklewcmpgh";
            osc8-underline = "url-mode";
            protocols = "http, https, ftp, ftps, file";
            uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
          };
          mouse = {
            hide-when-typing = "yes";
          };
          colors = {
            foreground = "d9e0ee";
            background = "292a37";
            ## Normal/regular colors (color palette 0-7)
            regular0 = "303241"; # black
            regular1 = "ec6a88";
            regular2 = "3fdaa4";
            regular3 = "efb993";
            regular4 = "3fc6de";
            regular5 = "b771dc";
            regular6 = "6be6e6";
            regular7 = "d9e0ee";

            bright0 = "393a4d"; # bright black
            bright1 = "e95678"; # bright red
            bright2 = "29d398"; # bright green
            bright3 = "efb993"; # bright yellow
            bright4 = "26bbd9";
            bright5 = "b072d1"; # bright magenta
            bright6 = "59e3e3"; # bright cyan
            bright7 = "d9e0ee"; # bright white
          };
        };
      };
    };
  };
}
