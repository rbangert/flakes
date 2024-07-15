{
  lib,
  pkgs,
  namespace,
  ...
}:
with lib.${namespace}; {
  rr-sv = {
    applications = {
      emacs = enabled;
      qutebrowser = enabled;
    };

    desktop = {
      alacritty = enabled;
      dunst = enabled;
      hyprland = enabled;
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

  manual.json.enable = true;

  home = {
    packages = with pkgs; [
      pandoc
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
      obsidian

      gimp
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
    ];

    sessionVariables = {EDITOR = "nvim";};
  };

  stylix = {
    enable = true;
    autoEnable = true;
    fonts.sizes.applications = 10;
  };
}
