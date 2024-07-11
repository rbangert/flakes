{
  lib,
  pkgs,
  config,
  osConfig ? {},
  format ? "unknown",
  namespace,
  ...
}:
with lib.${namespace}; {
  rr-sv = {
    desktop = {
      alacritty = enabled;
      dunst = enabled;
      hyprland = enabled;
      # qutebrowser = enabled;
      rofi = enabled;
    };

    cli-apps = {
      atuin = enabled;
      zsh = enabled;
      tmux = enabled;
      starship = enabled;
      neovim = enabled;
      home-manager = enabled;
    };

    tools = {
      ssh = enabled;
      git = enabled;
      direnv = enabled;
      nix = enabled;
      system = enabled;
    };
  };

  home = {
    packages = with pkgs; [
      neovim
      #firefox-bin
      yt-dlp
      ytfzf
      age
      calcure

      calcurse
      kicad
      freecad
      spice-gtk
      #rofi
      #rofi-calc
      #rofi-emoji
      #rofi-pass
      #rofi-rbw-wayland
      buku
      eza
      cht-sh
      wtf
      obsidian

      gimp
      bottom
      ranger
      _1password
      _1password-gui

      ripcord
      gnupg
      gpg-tui
      gpa

      # ytmdl

      #youtube-dl
      vimpc
      mpd
      obs-studio

      glow
      blender

      libreoffice

      hunspell
      hunspellDicts.en_US

      xfce.thunar
      inkscape
      mailpit

      discord

      brave
      gotify-cli
      gotify-desktop
      bitwarden
      bitwarden-cli
      rbw

      xxh
      navi
      # dev
      vscode

      gh
      gh-dash
      oh-my-git
      lazygit

      caddy
      devbox
      firefox-devedition
      awscli2
      fh

      perl
      pwgen

      charm
      gum
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      vimdiff = "nvim -d";
    };
  };
}
