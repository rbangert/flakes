{ lib, pkgs, namespace, ... }:
with lib.${namespace}; {
  rr-sv = {
    applications = {
      emacs = enabled;
      # INFO keybase kbfs package currently broken
      foot = enabled;
      qutebrowser = enabled;
    };

    desktop = {
      alacritty = enabled;
      dunst = enabled;
      hyprland = enabled;
      rofi = enabled;
      fuzzel = enabled;
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

  manual.json.enable = true;

  home = {
    packages = with pkgs; [
      #firefox-bin
      yt-dlp
      ytfzf
      age
      calcure
      htop
      remmina

      calcurse
      kicad
      freecad
      spice-gtk
      obsidian
      nextcloud-client

      gimp

      ripcord
      gnupg
      gpg-tui
      gpa

      # ytmdl

      #youtube-dl
      vimpc
      mpd
      obs-studio

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
      rofi-rbw
      bitwarden-menu

      xxh
      # dev
      vscode
      go
      hugo
      nodePackages.prettier

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
    ];
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = false;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    fonts.sizes.applications = 10;
  };
}
