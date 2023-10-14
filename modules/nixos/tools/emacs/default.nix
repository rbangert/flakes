{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.rr-sv;
let cfg = config.rr-sv.tools.emacs;
in {
  options.rr-sv.tools.emacs = with types; {
    enable = mkBoolOpt true "Whether or not to manage emacs configuration.";
  };

  config = mkIf cfg.enable {
    services.emacs.enable = true;

    environment.systemPackages = with pkgs; [
      binutils
      emacs29-pgtk
      git
      wget
      ripgrep
      gnutls
      coreutils
      fd
      imagemagick
      clang
      (mkIf (config.programs.gnupg.agent.enable) pinentry_emacs)
      zstd
      ## Module dependencies
      # :vterm-module
      cmake
      libtool
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      fava
    ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    rr-sv.home.extraOptions = {
      home.shellAliases = { "emc" = "emacsclient -c -a 'emacs'"; };
      programs.emacs = {
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
      };
    };

  };
}
