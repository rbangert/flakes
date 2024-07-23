{ config, inputs, pkgs, lib, ... }:
with lib;
with lib.rr-sv; {
  imports = [ ./hardware.nix ];

  programs.extra-container.enable = true;
  rr-sv = {
    services = {
      openssh = enabled;
      tailscale = enabled;
      # nextcloud = enabled;
    };

    nix = { os = enabled; };
  };

  sops = {
    defaultSopsFile = ../../../secrets/kore/secrets.yaml;
    secrets = {
      email = { };
      tailscale_token = { };
      cf-tunnel_token = { };
      acmecredfile = { };
      ssh_host_key = { };
      nextcloud_pass = {
        owner = "nextcloud";
        group = "nextcloud";
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "rbangert@proton.me";
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking = {
    hostName = "kore";
    domain = "kore.russellb.dev";
    enableIPv6 = true;
    networkmanager.enable = true;
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "ens3";
      enableIPv6 = true;
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [ 443 80 ];
      allowedUDPPorts = [ 443 80 ];
      allowPing = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
  ];

  users.users.russ = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEf8/lOV9CoafN4j76Hk9fZtP4MgR07KXus8qKuuvpMk russ@algol"
    ];
    extraGroups =
      [ "polkituser" "wheel" "audio" "libvirtd" "input" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [ git neovim ];

  security = {
    rtkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    doas = {
      enable = true;
      extraRules = [{
        users = [ "russ" ];
        keepEnv = true;
        persist = true;
      }];
    };
    protectKernelImage = true;
    unprivilegedUsernsClone = true;
  };

  system = {
    stateVersion = "24.05";
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
