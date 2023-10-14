{ options, config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.tools.nb;
in
{
  options.rr-sv.tools.nb = with types; {
    enable = mkBoolOpt false "Whether or not to enable nb";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
      pandoc
      tig
      w3m
      ack
      asciidoctor
      silver-searcher
      catimg
      chafa
      eza
      imagemagick
      gnupg
      highlight
      imgcat
      joshuto
      lsd
      links2
      lynx
      mc
      mpg123
      mplayer
      python311Packages.pdftotext
      python311Packages.pygments
      ranger
      readability-cli
      sc-im
      vifm
      viu
      nb
    ];
  };
}
