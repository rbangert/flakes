{
  description = "RR-SV Flakes";

  inputs = {
    ## Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    ## Tools
    nix-search-cli.url = "github:peterldowns/nix-search-cli";
    nix-search-cli.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "unstable";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    nixd.url = "github:nix-community/nixd";
    nil-lsp.url = "github:oxalica/nil";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    fleek.url = "https://flakehub.com/f/ublue-os/fleek/0.10.4.tar.gz";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    flake-checker.url = "github:DeterminateSystems/flake-checker";
    flake-checker.inputs.nixpkgs.follows = "nixpkgs";

    snowfall-flake.url = "github:snowfallorg/flake";
    snowfall-flake.inputs.nixpkgs.follows = "unstable";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    nix-script.url = "github:BrianHicks/nix-script";
    nix-script.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: explore nixpkgs-wayland
    #nixpkgs-wayland.url =
    #  "github:nix-community/nixpkgs-wayland";
    #nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
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
  in
    lib.mkFlake {
      channels-config.allowUnfree = true;

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
        #nix-alien.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        vscode-server.nixosModules.default
        nix-ld.nixosModules.nix-ld
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
      ];
    };
}
