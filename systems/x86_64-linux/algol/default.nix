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
      zsh = enabled;
    };

    tools = {
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

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  networking = {
    hostName = "algol";
    hostId = "edf1e63e";
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };

  services = {
    tailscale.enable = true;
    xserver = {
      layout = "us";
      xkbVariant = "";
    };
    openssh = {
      enable = true;
      settings = {PasswordAuthentication = false;};
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

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

  nixpkgs.config.allowUnfree = true;

  programs = {
    nix-ld.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  environment.systemPackages = with pkgs; [
    btm
  ];
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
