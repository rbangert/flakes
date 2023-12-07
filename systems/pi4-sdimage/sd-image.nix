{ inputs
, pkgs
, lib
, ...
}:
with lib;
with lib.rr-sv; {

  nixpkgs.crossSystem.system = "armv7l-linux";

  imports = [
  <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  ];

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

  services = {
      tailscale.enable = true;
      openssh.enable = true;
    };

  }


