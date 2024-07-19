{ options, config, lib, pkgs, ... }:
with lib;
with lib.rr-sv;
let cfg = config.rr-sv.applications.foot;
in {
  options.rr-sv.applications.foot = with types; {
    enable = mkBoolOpt false "Whether or not to enable foot.";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          # font = "JetBrainsMono Nerdfont:size=10:line-height=16px";
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
          uri-characters = ''
            abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]'';
        };
        mouse = { hide-when-typing = "yes"; };
      };
    };
  };
}
