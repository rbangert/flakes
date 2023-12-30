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
  rr-sv = {
    suites.server = enabled;
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

  system.stateVersion = "24.05";
}
