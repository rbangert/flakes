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

  # sops = {
  #   defaultSopsFile = ../../../secrets/kore/secrets.yaml;
  #   secrets = {
  #     email = { };
  #     tailscale_token = { };
  #     cf-tunnel_token = { };
  #     acmecredfile = { };
  #     ssh_host_key = { };
  #     nextcloud_pass = { };
  #   };
  # };

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
  networking.hostName = "kore";
  networking.domain = "kore.russellb.dev";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
  ];
  system.stateVersion = "24.05";
}
