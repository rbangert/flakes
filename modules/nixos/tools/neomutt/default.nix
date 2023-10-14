{ config, lib, pkgs, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.tools.neomutt;
in
{
  options.rr-sv.tools.neomutt = with types; {
    enable = mkBoolOpt false "Whether or not to enable neomutt";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neomutt
      mutt-wizard
      isync
      curl
      msmtp
      pass
      cacert
      gettext
      pam_gnupg
      lynx
      notmuch
      abook
      urlview
      cron
      mpop
    ];
  };
}
