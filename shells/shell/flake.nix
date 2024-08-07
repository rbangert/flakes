# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs,
  lib,
  inputs,
  stdenv ?
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

    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
      gnupg
      rnix-lsp
      nixfmt-rfc-style
      nixpkgs-fmt
      spellcheck
    ];
    NIX_CONFIG = "experimental-features = nix-command flakes";
  };
}
