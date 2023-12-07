{ pkgs, config, lib, modulesPath, inputs, ... }:

with lib;
with lib.rr-sv;

  rr-sv = {
    suites.server = enabled;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "herse";
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
    paperless-ng = {
        enable = true;
        address = "0.0.0.0";
        port = 8000;
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

  # Enable passwordless sudo.
  security.sudo.extraRules= [
    {  users = [ user ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  services.xserver = {
    enable = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  hardware.pulseaudio.enable = true;

  system.stateVersion = "23.11";
}
