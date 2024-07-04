{
  pkgs ?
  # If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock =
      (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}: {
  default = pkgs.mkShell {
    shellHook = ''
            clear
            echo "
      _______   _           _
      |  ____| | |         | |
      | |__    | |   __ _  | | __   ___   ___
      |  __|   | |  / _\` | | |/ /  / _ \ / __|
      | |      | | | (_| | |   <  |  __/ \\__ \\
      |_|      |_|  \__,_| |_|\_\  \___| |___/
            "
              export PS1="[\e[0;34m(Flakes)\$\e[m:\w]\$ "
    '';
    packages = with pkgs; [
      nix
      git
      gnupg
      cachix
      lorri
      niv
      nurl
      nixfmt-rfc-style
      statix
      vulnix
      home-manager
      haskellPackages.dhall-nix
      nixpkgs-fmt
      rnix-lsp
    ];
  };
}
