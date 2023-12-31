{
  inputs,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.rr-sv; {
  imports = [./hardware.nix];

  programs.extra-container.enable = true;

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "algol";
      systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];

  services.syncthing.extraOptions.gui = {
    user = "russ";
    password = "password";
  };

  rr-sv = {
    virtualisation = {
      libvirtd = enabled;
      podman = enabled;
      incus = enabled;
      lxc = enabled;
    };

    services = {
      openssh = enabled;
      syncthing = enabled;
      tailscale = enabled;
    };

    containers = {
      caddy = enabled;
      mattermost = enabled;
    };
  };

  boot.cleanTmpDir = true;
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
      allowedTCPPorts = [8384 443 80];
      #    allowedUDPPorts = [ 443 80 44857 ];
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

  system.stateVersion = "23.11";
}
