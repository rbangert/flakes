{
  description = "RR-SV Flakes";

  inputs = {
    ## Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils-plus = { url = "github:gytis-ivaskevicius/flake-utils-plus"; };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    snowfall-thaw = {
      url = "github:snowfallorg/thaw";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake.url = "github:snowfallorg/flake";
    snowfall-flake.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-frost.url = "github:snowfallorg/frost";
    snowfall-frost.inputs.nixpkgs.follows = "nixpkgs";

    # plusultra = {
    #   url = "github:jakehamilton/config";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.unstable.follows = "unstable";
    # };

    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    ## Tools

    # Tmux
    # tmux.url = "github:rbangert/tmux";
    # tmux.inputs = {
    #   nixpkgs.follows = "nixpkgs";
    #   unstable.follows = "unstable";
    # };

    neovim.url = "github:rbangert/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";

    nix-search-cli.url = "github:peterldowns/nix-search-cli";
    nix-search-cli.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-script.url = "github:BrianHicks/nix-script";
    nix-script.inputs.nixpkgs.follows = "nixpkgs";

    # Doom Emacs
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "emacs-pin-nixpkgs";
    emacs-pin-nixpkgs.url = "nixpkgs/f72123158996b8d4449de481897d855bc47c7bf6";
    nix-straight.url = "github:librephoenix/nix-straight.el/pgtk-patch";
    nix-straight.flake = false;
    nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";

    eaf = {
      url = "github:emacs-eaf/emacs-application-framework";
      flake = false;
    };
    eaf-browser = {
      url = "github:emacs-eaf/eaf-browser";
      flake = false;
    };
    org-nursery = {
      url = "github:chrisbarrett/nursery";
      flake = false;
    };
    org-yaap = {
      url = "gitlab:tygrdev/org-yaap";
      flake = false;
    };
    org-side-tree = {
      url = "github:localauthor/org-side-tree";
      flake = false;
    };
    org-timeblock = {
      url = "github:ichernyshovvv/org-timeblock";
      flake = false;
    };
    org-krita = {
      url = "github:librephoenix/org-krita";
      flake = false;
    };
    org-xournalpp = {
      url = "gitlab:vherrmann/org-xournalpp";
      flake = false;
    };
    org-sliced-images = {
      url = "github:jcfk/org-sliced-images";
      flake = false;
    };
    magit-file-icons = {
      url = "github:librephoenix/magit-file-icons/abstract-icon-getters-compat";
      flake = false;
    };
    phscroll = {
      url = "github:misohena/phscroll";
      flake = false;
    };
    mini-frame = {
      url = "github:muffinmad/emacs-mini-frame";
      flake = false;
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          namespace = "rr-sv";
          meta = {
            name = "";
            title = "";
          };
        };
      };
    in lib.mkFlake {
      channels-config.allowUnfree = true;

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
        snowfall-frost.overlays."package/frost"
        snowfall-thaw.overlays."package/thaw"
        neovim.overlays.default
      ];

      homes.users."russ@io".modules = with inputs; [
        sops-nix.homeManagerModules.sops
        nix-doom-emacs.hmModule
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        microvm.nixosModules.host
      ];

      deploy = lib.mkDeploy { inherit (inputs) self; };

      checks = builtins.mapAttrs
        (system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;

      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-rfc-style;
      };
    } // {
      self = inputs.self;
    };
}
