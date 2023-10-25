{ inputs
, pkgs
, lib
, ...
}:
with lib;
with lib.rr-sv; {
  imports = [ ./hardware.nix ];

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
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  # Enable swap on luks
  boot.initrd.luks.devices."luks-cfa2a423-7810-4917-b4e0-f9fea138d7ac".device = "/dev/disk/by-uuid/cfa2a423-7810-4917-b4e0-f9fea138d7ac";
  boot.initrd.luks.devices."luks-cfa2a423-7810-4917-b4e0-f9fea138d7ac".keyFile = "/crypto_keyfile.bin";

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
    ventoy
    btop
    polkit
    yt-dlp
    ytfzf
    xorg.xinit
    xorg.xsetroot
    qutebrowser
    thunderbird
    chromium
    python311Packages.setproctitle
    zoom-us
    xclip
    picom
    xdotool
    xorg.xbacklight
    light
    feh
    calcurse
    rofi
    buku
    eza
    cht-sh
    dash
    dmenu
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
    stig
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
    obsidian
    mattermost-desktop
    jitsi-meet-electron
    inkscape
    discord
    element-desktop
    firefox
    tor
    tailscale
    librewolf
    brave
    gotify-cli
    gotify-desktop
    #shell
    xxh
    navi
    # dev
    vial
    distrobox
    caddy
    devbox
    vscode
    teams-for-linux
    microsoft-edge
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
    nixfmt
    nurl
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
    python311Packages.pip
    python311Packages.websockets
    python311Packages.packaging
    python311Packages.six
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
          users = [ "russ" ];
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
