{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.applications.emacs;
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
      ripgrep
      gnutls
      coreutils
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
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang beancount
      beancount
      emacs-all-the-icons-fonts
      fava
      multimarkdown
      emacsPackages.prettier-js
    ];

    services.emacs = {enable = true;};
  };
}
