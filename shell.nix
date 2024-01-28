# Shell for bootstrapping flake-enabled nix and other tooling
{ pkgs ? # If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs { overlays = [ ]; }
, ...
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

    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      gnupg
      rnix-lsp
      nixd
      nixfmt
      nixpkgs-fmt
      nix-tree
      nurl
      alejandra
      deploy-rs
      nix-index
      nix-prefetch-git
      nix-output-monitor
      #flake-checker
    ];
    NIX_CONFIG = "experimental-features = nix-command flakes";
  };
}
