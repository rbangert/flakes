{nix-search-cli, ...}: final: prev: {
  inherit (nix-search-cli.packages.${prev.system}) nix-search;
}
