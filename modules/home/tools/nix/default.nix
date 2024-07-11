{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.tools.nix;
in {
  options.${namespace}.tools.nix = {
    enable = mkEnableOption "nix tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        snowfallorg.frost
        snowfallorg.flake
        snowfallorg.thaw
        any-nix-shell
        nixos-generators
        sops
        nurl
        niv
        ssh-to-age
        age
        alejandra
        deploy-rs
        nixfmt-rfc-style
        nix-index
        nix-prefetch-git
        nix-output-monitor
        nix-search
        manix
      ];
    };
  };
}
