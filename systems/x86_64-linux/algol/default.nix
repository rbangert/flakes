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
    # ./disko.nix
  ];

  rr-sv = {
    shell = {
      atuin = enabled;
      starship = enabled;
      tmux = enabled;
      zsh = enabled;
    };

    tools = {
      direnv = enabled;
      git = enabled;
    };

    virtualisation = {
      podman = enabled;
      incus = enabled;
      libvirtd = enabled;
      lxc = enabled;
    };

    services = {
      openssh = enabled;
      syncthing = enabled;
      tailscale = enabled;
      nfs = enabled;
    };

    suites = {
      common = enabled;
    };

    nix = {
      os = enabled;
      flake = enabled;
    };

    system = {
      env = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  # enabling zfs
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = ["zpool"];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = false;

  networking = {
    hostName = "algol";
    hostId = "edf1e63e";
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };

  users.users = {
    root = {
      initialHashedPassword = "$6$ix1Uuo.tPzRokU0z$3oalZuzkbaUTou99VttgwgwNsExZx6KX0heKq3t0jDaWEpRBL5Jk71M8jM2CCIUjoK4SQfhFkNWa.ENZdGyJT.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
      ];
    };

    russ = {
      isNormalUser = true;
      description = "russ";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
      ];
      extraGroups = [
        "polkituser"
        "wheel"
        "audio"
        "docker"
        "podman"
        "lxd"
        "libvirtd"
        "input"
        "networkmanager"
      ];
    };
  };

  programs = {
    nix-ld.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    rtkit.enable = true;
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

  system.stateVersion = "23.11";
}
