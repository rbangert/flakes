{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.rr-sv; {
  imports = [./hardware.nix];

  rr-sv = {
    suites.common = enabled;

    desktop = {
      hyprland = enabled;
      rofi = enabled;
      dunst = enabled;
      eww = enabled;
      alacritty = enabled;
      foot = enabled;
    };

    shell = {
      # zellij = enabled;
      zsh = enabled;
      atuin = enabled;
      starship = enabled;
      tmux = enabled;
    };

    tools = {
      direnv = enabled;
      emacs = enabled;
      git = enabled;
      nb = enabled;
      ssh = enabled;
      neomutt = enabled;
      taskwarrior = enabled;
    };

    virtualisation = {
      libvirtd = enabled;
      podman = enabled;
    };

    services = {
      openssh = enabled;
      taskserver = enabled;
    };

    nix = {
      os = enabled;
      flake = enabled;
    };

    system = {
      boot = enabled;
      env = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
      printer = enabled;
    };
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  networking = {
    hostName = "io";
    enableIPv6 = false;
    networkmanager.enable = true;
    #wireless.iwd.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      #    allowedTCPPorts = [ 443 80 ];
      #    allowedUDPPorts = [ 443 80 44857 ];
      #    allowPing = false;
    };
  };

  # Setup keyfile
  boot.initrd.luks.devices."luks-2e68c365-0b8b-414b-a01c-c3c4455a01de".device = "/dev/disk/by-uuid/2e68c365-0b8b-414b-a01c-c3c4455a01de";

  users.users.russ = {
    isNormalUser = true;
    #InitialHashedPassword =
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
    ];
    extraGroups = [
      "polkituser"
      "wheel"
      "audio"
      "docker"
      "podman"
      "libvirtd"
      "input"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    # laptop stuff
    acpi
    tlp
    # essentials
    nmap
    unzip
    neomutt
    talosctl
    youtrack
    ventoy
    btop
    polkit
    yt-dlp
    ytfzf
    xorg.xinit
    qmk
    xorg.xsetroot
    quickemu
    dfu-util
    qutebrowser
    thunderbird
    age
    chromium
    at
    ddcutil
    zoom-us
    xclip
    picom
    xdotool
    xorg.xbacklight
    light
    asciiquarium
    calcure
    feh
    calcurse
    kicad
    spice-gtk
    rofi
    rofi-calc
    rofi-emoji
    rofi-pass
    rofi-rbw-wayland
    buku
    eza
    cht-sh
    wtf
    dash
    dmenu
    gimp
    bottom
    ranger
    signal-desktop
    ripcord
    gnupg
    gpg-tui
    gpa
    killall
    super-productivity
    ytmdl
    transmission
    arandr
    youtube-dl
    vimpc
    mpd
    obs-studio
    remmina
    wego
    glow
    kitty
    coreutils-full
    libreoffice
    gparted
    hunspell
    hunspellDicts.en_US
    tabview
    any-nix-shell
    alacritty
    xfce.thunar
    mattermost-desktop
    jitsi-meet-electron
    inkscape
    discord
    element-desktop
    firefox-bin
    tor

    tailscale
    librewolf
    brave
    gotify-cli
    gotify-desktop
    bitwarden
    bitwarden-cli
    rbw
    spotify-tui
    spotify-cli-linux
    xxh
    navi
    # dev
    vscode
    vial
    distrobox
    gh
    gh-dash
    oh-my-git
    lazygit
    httrack
    caddy
    devbox
    firefox-devedition-bin
    fh
    lazygit
    rustup
    nix-script
    perl
    git
    pwgen
    vim
    neovim
    jdk11
    jre8
    luajitPackages.luarocks-nix
    css-html-js-minify
    lemminx
    terraform-ls
    gopls
    charm
    gum
    screen
    nixfmt
    nurl
    sops
    nixpkgs-fmt
    nixos-generators
    ## lazyvim
    vimwiki-markdown
    tree-sitter
    stylua
    diffuse
    fd
    gccgo13
    gnumake
    # inet tools
    dig
    whois
    inetutils
  ];

  # TODO refactor io/default.nix
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.dev.enable = true;
  };

  # TODO: import hlissners home.nix
  location.latitude = 41.47;
  location.longitude = -107.14;

  services = {
    atd.enable = true;
    tailscale.enable = true;
    picom.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin.enable = true;
        autoLogin.user = "russ";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["russ"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    protectKernelImage = true;
    unprivilegedUsernsClone = true;
  };

  sound.enable = true;

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        libvdpau-va-gl
      ];
    };
  };

  system = {
    stateVersion = "23.05";
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
