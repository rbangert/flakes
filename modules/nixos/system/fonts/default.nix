{ config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.system.fonts;
in
{
  options.rr-sv.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to enable fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        fantasque-sans-mono
        terminus_font
        jetbrains-mono
        nerdfonts
        font-awesome
        icon-library
        weather-icons
        material-icons
        material-design-icons
        material-symbols
        openmoji-color
        lexend
        jost
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];
      fontconfig = {
        hinting.autohint = true;
        defaultFonts = {
          serif = [ "Noto Serif" "Noto Color Emoji" ];
          sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
          monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
