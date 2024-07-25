{ pkgs, lib, namespace, ... }:
with lib;
with lib.${namespace}; {
  imports = [ ./hardware.nix ];

  rr-sv = {
    virtualisation = {
      libvirtd = enabled;
      podman = enabled;
    };

    containers = { home-assistant = enabled; };

    services = {
      openssh = enabled;
      tailscale = { enable = true; };
      wego = enabled;
    };

    nix = { os = enabled; };

    system = {
      env = enabled;
      fonts = enabled;
      locale = enabled;
      security = enabled;
      style = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  sops = {
    defaultSopsFile = ../../../secrets/io/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      github_token = { };
      wegorc = { };
      davfs2 = {
        owner = "russ";
        mode = "0600";
        path = "/home/russ/.davfs2/secrets";
      };
      tailscale_token = { };
      atuin_key = { owner = "russ"; };
      ssh_key = { };
      ssh_host_key = { };
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9e34c1d5-82e4-41e2-a175-b282cb4e6570";
      preLVM = true;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;

  users = {
    mutableUsers = false;
    users.root.hashedPassword =
      "$y$j9T$G6KGvLUo7/6YGsO/Ry9EC1$CQtgp/336k/4ozVfiQL2Z.3EgcosEOYpL8G8yGALDN2";
  };

  networking = {
    hostName = "io";
    enableIPv6 = false;
    # useNetworkd = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
    };
  };

  # # For microvm's + useNetworkd ^^ in networking = { ... } above
  # systemd.network.enable = true;

  # systemd.network.networks."10-lan" = {
  #   matchConfig.Name = [ "eno1" "vm-*" ];
  #   networkConfig = { Bridge = "br0"; };
  # };

  # systemd.network.netdevs."br0" = {
  #   netdevConfig = {
  #     Name = "br0";
  #     Kind = "bridge";
  #   };
  # };

  # systemd.network.networks."10-lan-bridge" = {
  #   matchConfig.Name = "br0";
  #   networkConfig = {
  #     Address = [ "192.168.1.2/24" "2001:db8::a/64" ];
  #     Gateway = "192.168.1.1";
  #     DNS = [ "192.168.1.1" ];
  #     IPv6AcceptRA = true;
  #   };
  #   linkConfig.RequiredForOnline = "routable";
  # };

  users.users.russ = {
    isNormalUser = true;
    hashedPassword =
      "$y$j9T$r9dv0dKsFPwUei7ujvARr.$dAiCl/QC.gyirBhj.SXQyJokg5H5789uVM4Y7n4OsP8";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7fghe/cS7r7e94cQivF3rI7EAHV6XUrBld+07dgg6s russ@dia"
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
    gettext
    bash
    firefox-bin

    # laptop stuff
    acpi
    tlp
    # essentials
    # polkit
    xorg.xinit
    qmk
    xorg.xsetroot
    quickemu
    xorg.xbacklight
    light
    dash
    # dev
    vial
    rustup
    perl
    pwgen
    jdk11
    jre8
    charm
    gum
  ];

  # TODO refactor io/default.nix
  programs = {
    mtr.enable = true;
    hyprland.enable = true;
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
  };

  security.pam.services = {
    hyprlock = { };
    gdm.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
  };

  boot.plymouth = { enable = true; };

  # TODO: import hlissners home.nix
  location.latitude = 37.73;
  location.longitude = -119.57;

  services = {
    tumbler.enable = true;
    dbus.enable = true;
    libinput.enable = true;
    atd.enable = true;
    tailscale.enable = true;
    gvfs.enable = true;
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "russ";
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # davfs2 = {
    #   enable = true;
    #   davUser = "russ";
    #   settings = {

    #   };
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
    stateVersion = "23.11";
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
