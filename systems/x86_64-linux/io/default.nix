{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.rr-sv; {
  imports = [
    ./hardware.nix
  ];

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
      neovim = enabled;
      taskwarrior = enabled;
      yubikey = enabled;
    };

    virtualisation = {
      libvirtd = enabled;
      podman = enabled;
    };

    services = {
      openssh = enabled;
      syncthing = enabled;
      tailscale = enabled;
      taskserver = enabled;
    };

    nix = {
      os = enabled;
      flake = enabled;
    };

    system = {
      env = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
      printer = enabled;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users = {
    mutableUsers = false;
    users.root.initialHashedPassword = "$y$j9T$a2t7BLAmUzodcdXnY.A9Q.$vDBzrWbHKVeE/Kpyfk1mkytNwTfCDxyUFMp3NhOQa09";
  };

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
    usbutils
    nmap
    unzip
    neomutt
    talosctl
    youtrack
    nfs-utils
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
    #kicad
    #freecad
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
    _1password
    _1password-gui
    signal-desktop
    ripcord
    gnupg
    gpg-tui
    gpa
    killall
    super-productivity
    # ytmdl
    transmission
    arandr
    youtube-dl
    vimpc
    mpd
    obs-studio
    remmina
    wego
    glow
    blender
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
    caprine-bin
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
    gvfs.enable = true;
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
