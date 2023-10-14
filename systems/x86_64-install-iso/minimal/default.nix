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
    #./disko-config.nix
  ];

  rr-sv = {
    shell = {
      zsh = enabled;
      tmux = enabled;
      starship = enabled;
      atuin = enabled;
    };

    tools = {
      git = enabled;
      direnv = enabled;
    };

    virtualization = {
      libvirtd = enabled;
      podman = enabled;
    };

    services = {
      syncthing = enabled;
      taskserver = enabled;
      # TODO tailscale = enabled;
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
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = false;

  networking = {
    hostName = "algol";
    firewall = {
      enable = true;
      checkReversePath = "loose";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services = {
    vscode-server.enable = true;
    xserver = {
      layout = "us";
      xkbVariant = "";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.russ = {
    isNormalUser = true;
    description = "russ";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdfj6SbSBSWs2medcA8jKdFmVT1CL8l6iXTCyPUsw7y russ@rr-sv.win"
    ];
    extraGroups = ["wheel" "audio" "docker" "podman" "libvirtd" "input" "networkmanager"];
    packages = with pkgs; [
      stig
      #dev
      charm
      gum
      nixfmt
      nurl
      nixpkgs-fmt
      nixos-generators
      ## neovim/lunarvim
      diffuse
      gccgo13
      gnumake
      python311Packages.pip
      python311Packages.websockets
      nodejs_20
      cargo
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

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

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };

  system.stateVersion = "23.05";
}
