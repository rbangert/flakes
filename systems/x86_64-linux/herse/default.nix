{
  config,
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

  programs.extra-container.enable = true;

  rr-sv = {
    virtualisation = {
      libvirtd = enabled;
      podman = enabled;
      # incus = enabled;
      lxc = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;
    };

    containers = {
      gotify = enabled;
      gitea = enabled;
      mattermost = enabled;
    };
  };

  sops = {
    defaultSopsFile = ../../../secrets/herse/acme.yaml;
    secrets = {
      email = {};
      acmeCredFile = {};
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rbangert@proton.me";
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;

  networking = {
    hostName = "herse";
    enableIPv6 = true;
    networkmanager.enable = true;
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
      enableIPv6 = true;
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [443 80];
      allowedUDPPorts = [443 80];
      allowPing = false;
    };
  };

  users.users.russ = {
    isNormalUser = true;
    #InitialHashedPassword =
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEf8/lOV9CoafN4j76Hk9fZtP4MgR07KXus8qKuuvpMk russ@algol"
    ];
    extraGroups = [
      "polkituser"
      "wheel"
      "audio"
      "libvirtd"
      "input"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

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

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
