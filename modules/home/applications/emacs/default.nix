{ lib, config, pkgs, namespace, ... }:
with lib;
with lib.${namespace};
let cfg = config.${namespace}.applications.emacs;
in {
  options.${namespace}.applications.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    accounts.email.accounts."russellb.dev" = {
      address = "mail@russellb.dev";
      userName = "mail@russellb.dev";
      passwordCommand = ''
        pass show email/russellb.dev
      '';
      primary = true;
      realName = "Russell Bangert";
      # signature = {
      # command =
      # delimiter
      # text
      # };
      smtp = {
        host = "smtppro.zoho.com";
        port = 465;
        tls.enable = true;
      };
      imap = {
        host = "imappro.zoho.com";
        port = 993;
        tls.enable = true;
      };
    };

    home.packages = with pkgs; [
      mu
      emacs29-pgtk
      git
      wget
      zip
      ripgrep
      gnutls
      coreutils
      gnumake
      shellcheck
      terraform
      gopls
      gomodifytags
      gotests
      gore
      gotools
      scrot
      emacsPackages.mbsync
      shfmt
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
