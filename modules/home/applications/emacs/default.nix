{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.applications.emacs;
in {
  options.${namespace}.applications.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # binutils
      emacs29-pgtk
      git
      wget
      zip
      ripgrep
      gnutls
      coreutils
      gnumake
      terraform
      gopls
      gomodifytags
      gotests
      gore
      # guru
      scrot
      emacsPackages.mbsync
      shfmt
      # spellcheck
      graphviz
      ffmpeg
      fd
      jq
      imagemagick
      # clang
      pinentry-emacs
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
      ledger
      beancount
      emacs-all-the-icons-fonts
      fava
      multimarkdown
      gnuplot
      prettierd
      nil
      nixd
      emacsPackages.prettier
      emacsPackages.prettier-js
      nodePackages_latest.nodejs
    ];

    services.emacs = { enable = true; };
  };
}
