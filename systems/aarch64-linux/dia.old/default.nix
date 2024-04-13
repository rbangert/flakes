{
  pkgs,
  config,
  lib,
  modulesPath,
  inputs,
  ...
}:
with lib;
with lib.rr-sv; {
  imports = [./hardware.nix];

  rr-sv = {
    suites.server = enabled;

    virtualisation = {
      libvirtd = enabled;
      lxc = enabled;
      incus = enabled;
      podman = enabled;
    };
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "dia";
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    paperless = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
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
      "incus-admin"
    ];
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

  system.stateVersion = "23.11";
}
