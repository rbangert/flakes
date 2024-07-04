{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.rr-sv; let
  cfg = config.rr-sv.nix.os;
in {
  options.rr-sv.nix.os = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixUnstable "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alejandra
      deploy-rs
      nixfmt-rfc-style
      nix-index
      nix-prefetch-git
      nix-output-monitor
      nix-search
      #flake-checker
    ];

    nix = {
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        auto-optimise-store = true;
        allowed-users = ["russ"];
        warn-dirty = false;
        log-lines = 50;
        substituters = ["https://aseipp-nix-cache.global.ssl.fastly.net"];
        sandbox = "relaxed";
        keep-derivations = true;
        keep-outputs = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
